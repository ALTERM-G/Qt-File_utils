import os

from PySide6.QtCore import QObject, Signal, Slot


class ConversionWorker(QObject):
    finished = Signal(str)
    error = Signal(str)

    def __init__(self, input_path, file_type, output_format):
        super().__init__()
        self.input_path = input_path
        self.file_type = file_type
        self.output_format = output_format

    @Slot()
    def run_conversion(self):
        try:
            ext = self.output_format
            if not ext.startswith("."):
                ext = f".{ext}"
            dir_name = os.path.dirname(self.input_path)
            base_name = os.path.splitext(os.path.basename(self.input_path))[0]
            output_file = os.path.join(dir_name, f"{base_name}_converted{ext}")
            counter = 1
            while os.path.exists(output_file):
                output_file = os.path.join(
                    dir_name, f"{base_name}_converted_{counter}{ext}"
                )
                counter += 1

            print("Converting to:", output_file)
            if self.file_type == "Video":
                from backend.converters.video import convert_video

                result = convert_video(self.input_path, output_file)
            elif self.file_type == "Vector":
                from backend.converters.vector import convert_vector

                result = convert_vector(self.input_path, output_file)
            elif self.file_type == "Image":
                from backend.converters.image import convert_image

                result = convert_image(self.input_path, output_file)
            elif self.file_type == "Audio":
                from backend.converters.audio import convert_audio

                result = convert_audio(self.input_path, output_file)
            elif self.file_type == "Document":
                from backend.converters.document import convert_document

                result = convert_document(self.input_path, output_file)
            else:
                raise ValueError("Unsupported file type")

            self.finished.emit(result)
        except Exception as e:
            self.error.emit(str(e))
