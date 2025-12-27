from PySide6.QtCore import QObject, Slot, Signal, QThread
from backend.Worker import Worker
from backend.converters.video import convert_video
from backend.converters.vector import convert_vector
from backend.converters.image import convert_image
from backend.converters.audio import convert_audio
from backend.converters.document import convert_document

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
        self.worker = Worker(input_path, file_type, output_format)
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(lambda result: self._finish(result))
        self.worker.error.connect(lambda e: self._error(e))
        self.worker.finished.connect(self.thread.quit)
        self.worker.error.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.thread.start()

    def _finish(self, result_path):
        self.conversionFinished.emit(result_path)

    def _error(self, message):
        self.conversionError.emit(message)
