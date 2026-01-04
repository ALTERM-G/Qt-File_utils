import os
import tempfile
import shutil
from PySide6.QtCore import QObject, Signal

from backend.compressors.zip import compress_path_to_zip
from backend.compressors.rar import compress_path_to_rar
from backend.compressors.sevenz import compress_path_to_7z


class CompressionWorker(QObject):
    finished = Signal(str)
    error = Signal(str)

    def __init__(self, input_path, output_path, compression_format):
        super().__init__()
        self.input_path = input_path
        self.output_path = output_path
        self.compression_format = compression_format.strip().lower()

    def run(self):
        try:
            if isinstance(self.input_path, list):
                with tempfile.TemporaryDirectory() as tmpdir:
                    for file_path in self.input_path:
                        if not os.path.isfile(file_path):
                            continue
                        shutil.copy(file_path, os.path.join(tmpdir, os.path.basename(file_path)))
                    folder_to_compress = tmpdir
                    result_path = self._compress_folder(folder_to_compress)
            else:
                result_path = self._compress_folder(self.input_path)

            self.finished.emit(result_path)
        except Exception as e:
            self.error.emit(str(e))

    def _compress_folder(self, path):
        if self.compression_format == "zip":
            return compress_path_to_zip(path, self.output_path)
        elif self.compression_format == "rar":
            return compress_path_to_rar(path, self.output_path)
        elif self.compression_format == "7z":
            return compress_path_to_7z(path, self.output_path)
        else:
            raise ValueError(f"Unsupported format: {self.compression_format}")
