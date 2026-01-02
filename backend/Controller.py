import os

from PySide6.QtCore import QObject, QThread, Signal, Slot

from backend.Workers.CompressionWorker import CompressionWorker
from backend.Workers.ConvertionWorker import ConvertionWorker
from backend.converters.audio import convert_audio
from backend.converters.document import convert_document
from backend.converters.image import convert_image
from backend.converters.vector import convert_vector
from backend.converters.video import convert_video


class Controller(QObject):
    conversionStarted = Signal()
    conversionFinished = Signal(str)
    conversionError = Signal(str)

    @Slot(str, str, str)
    def convert(self, input_path, file_type, output_format):
        if not input_path:
            self.conversionError.emit("No file selected")
            return
        self.conversionStarted.emit()
        self.thread = QThread()
        self.worker = ConvertionWorker(input_path, file_type, output_format)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run_convertion)
        self.worker.finished.connect(self._finish)
        self.worker.error.connect(self._error)
        self.worker.finished.connect(self.thread.quit)
        self.worker.error.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()

    @Slot(str, str, str)
    def run_compression(self, input_path, output_folder, compression_format):
        if not input_path:
            self.conversionError.emit("No file selected")
            return

        compression_format = compression_format.lower()
        if compression_format not in ["zip", "rar"]:
            self.conversionError.emit(
                f"Unsupported compression format: {compression_format}"
            )
            return

        if os.path.isdir(input_path):
            name = os.path.basename(os.path.normpath(input_path))
        else:
            name, _ = os.path.splitext(os.path.basename(input_path))

        output_path = os.path.join(output_folder, f"{name}.{compression_format}")

        self.conversionStarted.emit()
        self.thread = QThread()
        self.worker = CompressionWorker(input_path, output_path, compression_format)
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
        self.conversionFinished.emit(result_path)

    def _error(self, message):
        self.conversionError.emit(message)
