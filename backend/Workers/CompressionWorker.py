from PySide6.QtCore import QObject, Signal

from backend.Compressor.zip_compressor import compress_path_to_zip


class CompressionWorker(QObject):
    finished = Signal(str)
    error = Signal(str)

    def __init__(self, input_path, output_path, compression_format):
        super().__init__()
        self.input_path = input_path
        self.output_path = output_path
        self.compression_format = compression_format.lower()

    def run(self):
        try:
            if self.compression_format == "zip":
                result_path = compress_path_to_zip(self.input_path, self.output_path)
                self.finished.emit(result_path)
            else:
                self.error.emit(f"Unsupported format: {self.compression_format}")
        except Exception as e:
            self.error.emit(str(e))
