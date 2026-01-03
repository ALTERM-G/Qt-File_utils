import os

from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtQml import QJSValue

from backend.Workers.CompressionWorker import CompressionWorker
from backend.Workers.ConversionWorker import ConversionWorker
from backend.converters.audio import convert_audio
from backend.converters.document import convert_document
from backend.converters.image import convert_image
from backend.converters.vector import convert_vector
from backend.converters.video import convert_video


class Controller(QObject):
    workingStarted = Signal()
    workingFinished = Signal(str)
    workingError = Signal(str)

    @Slot(str, str, str)
    def convert(self, input_path, file_type, output_format):
        if not input_path:
            self.conversionError.emit("No file selected")
            return
        self.workingStarted.emit()
        self.thread = QThread()
        self.worker = ConversionWorker(input_path, file_type, output_format)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run_conversion)
        self.worker.finished.connect(self._finish)
        self.worker.error.connect(self._error)
        self.worker.finished.connect(self.thread.quit)
        self.worker.error.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()


    @Slot('QVariant', str, str)
    def run_compression(self, input_paths, output_folder, compression_format):
        if isinstance(input_paths, QJSValue):
            input_paths = input_paths.toVariant()

        if not input_paths:
            self.conversionError.emit("No file selected")
            return

        compression_format = compression_format.lower()
        if compression_format not in ["zip", "rar", "7z"]:
            self.conversionError.emit(
                f"Unsupported compression format: {compression_format}"
            )
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
        self.thread = QThread()
        self.worker = CompressionWorker(input_paths, output_path, compression_format)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self._finish)
        self.worker.error.connect(self._error)
        self.worker.finished.connect(self.thread.quit)
        self.worker.error.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()


    def _finish(self, result_path):
        self.workingFinished.emit(result_path)

    def _error(self, message):
        self.workingError.emit(message)
