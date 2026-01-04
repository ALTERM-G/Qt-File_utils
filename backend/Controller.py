import os

from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtQml import QJSValue

from backend.Workers.CompressionWorker import CompressionWorker
from backend.Workers.ConversionWorker import ConversionWorker
from backend.Workers.ExtractionWorker import ExtractionWorker
from backend.converters.audio import convert_audio
from backend.converters.document import convert_document
from backend.converters.image import convert_image
from backend.converters.vector import convert_vector
from backend.converters.video import convert_video

class Controller(QObject):
    workingStarted = Signal()
    workingFinished = Signal(str)
    workingError = Signal(str)

    def __init__(self):
        super().__init__()
        self.active_threads = []
        self.max_threads = 3


    def _start_worker(self, worker_class, *args, **kwargs):
        if len(self.active_threads) >= self.max_threads:
            self.workingError.emit("Maximum number of simultaneous tasks reached")
            return

        thread = QThread()
        worker = worker_class(*args, **kwargs)
        worker.moveToThread(thread)
        thread.started.connect(worker.run if hasattr(worker, 'run') else worker.run_conversion)
        worker.finished.connect(lambda result: self._finish_worker(result, thread, worker))
        worker.error.connect(lambda e: self._error_worker(e, thread, worker))
        thread.start()
        self.active_threads.append(thread)


    @Slot(str, str, str)
    def run_conversion(self, input_path, file_type, output_format):
        if not input_path:
            self.workingError.emit("No file selected")
            return
        self.workingStarted.emit()
        self._start_worker(ConversionWorker, input_path, file_type, output_format)

    @Slot('QVariant', str, str)
    def run_compression(self, input_paths, output_folder, compression_format):
        if isinstance(input_paths, QJSValue):
            input_paths = input_paths.toVariant()

        if not input_paths:
            self.workingError.emit("No file selected")
            return

        compression_format = compression_format.lower()
        if compression_format not in ["zip", "rar", "7z"]:
            self.workingError.emit(f"Unsupported compression format: {compression_format}")
            return

        if isinstance(input_paths, list) and len(input_paths) > 1:
            name = "Compressed_Files"
        else:
            path = input_paths if isinstance(input_paths, str) else input_paths[0]
            if os.path.isdir(path):
                name = os.path.basename(os.path.normpath(path))
            else:
                name, _ = os.path.splitext(os.path.basename(path))

        output_path = os.path.join(output_folder, f"{name}.{compression_format}")

        self.workingStarted.emit()
        self._start_worker(CompressionWorker, input_paths, output_path, compression_format)

    @Slot('QVariant', str, str)
    def run_extraction(self, input_paths, output_path, extraction_type):
        if isinstance(input_paths, QJSValue):
            input_paths = input_paths.toVariant()

        if not input_paths:
            self.workingError.emit("No file selected")
            return

        extraction_type = extraction_type.lower()
        if extraction_type not in ["audio", "frames", "subtitles"]:
            self.workingError.emit(f"Unsupported extraction type: {extraction_type}")
            return

        self.workingStarted.emit()
        self._start_worker(ExtractionWorker, input_paths, output_path, extraction_type)

    def _finish_worker(self, result_path, thread, worker):
        self.workingFinished.emit(result_path)
        self._cleanup_thread(thread, worker)

    def _error_worker(self, error_message, thread, worker):
        self.workingError.emit(error_message)
        self._cleanup_thread(thread, worker)

    def _cleanup_thread(self, thread, worker):
        thread.quit()
        thread.wait()
        worker.deleteLater()
        thread.deleteLater()

        if thread in self.active_threads:
            self.active_threads.remove(thread)
