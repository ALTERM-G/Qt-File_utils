import os
from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtQml import QJSValue

from backend.Workers.CompressionWorker import CompressionWorker
from backend.Workers.ConversionWorker import ConversionWorker
from backend.Workers.ExtractionWorker import ExtractionWorker

class Controller(QObject):
    conversionStarted = Signal()
    conversionFinished = Signal(str)
    conversionError = Signal(str)

    compressionStarted = Signal()
    compressionFinished = Signal(str)
    compressionError = Signal(str)

    extractionStarted = Signal()
    extractionFinished = Signal(str)
    extractionError = Signal(str)

    def __init__(self):
        super().__init__()
        self.active_threads = []
        self.max_threads = 3

    # ------------------- Generic Worker Starter -------------------
    def _start_worker(self, worker_class, *args, started_signal=None, finished_signal=None, error_signal=None, **kwargs):
        if len(self.active_threads) >= self.max_threads:
            if error_signal:
                error_signal.emit("Maximum number of simultaneous tasks reached")
            return

        thread = QThread()
        worker = worker_class(*args, **kwargs)
        worker.moveToThread(thread)

        if started_signal:
            started_signal.emit()

        thread.started.connect(worker.run if hasattr(worker, "run") else worker.run_conversion)
        worker.finished.connect(lambda result: self._finish_worker(result, thread, worker, finished_signal))
        worker.error.connect(lambda e: self._error_worker(e, thread, worker, error_signal))
        thread.start()
        self.active_threads.append(thread)

    # ------------------- Conversion -------------------
    @Slot(str, str, str)
    def run_conversion(self, input_path, file_type, output_format):
        if not input_path:
            self.conversionError.emit("No file selected")
            return

        self._start_worker(
            ConversionWorker,
            input_path, file_type, output_format,
            started_signal=self.conversionStarted,
            finished_signal=self.conversionFinished,
            error_signal=self.conversionError
        )

    # ------------------- Compression -------------------
    @Slot('QVariant', str, str)
    def run_compression(self, input_paths, output_folder, compression_format):
        if isinstance(input_paths, QJSValue):
            input_paths = input_paths.toVariant()

        if not input_paths:
            self.compressionError.emit("No file selected")
            return

        compression_format = compression_format.lower()
        if compression_format not in ["zip", "rar", "7z"]:
            self.compressionError.emit(f"Unsupported compression format: {compression_format}")
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

        self._start_worker(
            CompressionWorker,
            input_paths, output_path, compression_format,
            started_signal=self.compressionStarted,
            finished_signal=self.compressionFinished,
            error_signal=self.compressionError
        )

    # ------------------- Extraction -------------------
    @Slot('QVariant', str, str)
    def run_extraction(self, input_paths, output_path, extraction_type):
        if isinstance(input_paths, QJSValue):
            input_paths = input_paths.toVariant()

        if not input_paths:
            self.extractionError.emit("No file selected")
            return

        extraction_type = extraction_type.lower()
        if extraction_type not in ["audio", "frames", "subtitles"]:
            self.extractionError.emit(f"Unsupported extraction type: {extraction_type}")
            return

        self._start_worker(
            ExtractionWorker,
            input_paths, output_path, extraction_type,
            started_signal=self.extractionStarted,
            finished_signal=self.extractionFinished,
            error_signal=self.extractionError
        )

    # ------------------- Worker Handlers -------------------
    def _finish_worker(self, result_path, thread, worker, signal=None):
        if signal:
            signal.emit(result_path)
        self._cleanup_thread(thread, worker)

    def _error_worker(self, error_message, thread, worker, signal=None):
        if signal:
            signal.emit(error_message)
        self._cleanup_thread(thread, worker)

    # ------------------- Thread Cleanup -------------------
    def _cleanup_thread(self, thread, worker):
        thread.quit()
        thread.wait()
        worker.deleteLater()
        thread.deleteLater()

        if thread in self.active_threads:
            self.active_threads.remove(thread)
