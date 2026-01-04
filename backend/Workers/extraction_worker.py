import os
import tempfile
from PySide6.QtCore import QObject, Signal

from backend.extractors.audio_extraction import extract_audio
from backend.extractors.frames_extraction import extract_frames
from backend.extractors.subtitles_extraction import extract_subtitles


class ExtractionWorker(QObject):
    finished = Signal(str)
    error = Signal(str)

    def __init__(self, input_path, output_path, extraction_type):
        super().__init__()
        self.input_path = input_path
        self.output_path = output_path
        self.extraction_type = extraction_type.strip().lower()

    def run(self):
        try:
            if isinstance(self.input_path, list):
                results = []
                for file_path in self.input_path:
                    if not os.path.exists(file_path):
                        continue
                    results.append(self._extract(file_path))
                self.finished.emit(", ".join(results))
            else:
                result_path = self._extract(self.input_path)
                self.finished.emit(result_path)
        except Exception as e:
            self.error.emit(str(e))

    def _extract(self, path):
        output_path = self.output_path
        if os.path.isdir(output_path) or output_path == "":
            folder = output_path if os.path.isdir(output_path) else os.path.dirname(path)
            base_name = os.path.splitext(os.path.basename(path))[0]

            if self.extraction_type == "audio":
                output_path = os.path.join(folder, f"{base_name}.aac")
            elif self.extraction_type == "frames":
                os.makedirs(self.output_path, exist_ok=True)
                output_pattern = os.path.join(self.output_path, "frame_%06d.png")
                cmd = ["ffmpeg", "-i", path, output_pattern]
                subprocess.run(cmd, check=True)
                return self.output_path
            elif self.extraction_type == "subtitles":
                output_path = os.path.join(folder, f"{base_name}.srt")
            else:
                raise ValueError(f"Unsupported extraction type: {self.extraction_type}")

        output_dir = os.path.dirname(output_path)
        if output_dir:
            os.makedirs(output_dir, exist_ok=True)

        if self.extraction_type == "audio":
            return extract_audio(path, output_path)
        elif self.extraction_type == "frames":
            return extract_frames(path, output_path)
        elif self.extraction_type == "subtitles":
            result = extract_subtitles(path, output_path)
            if result is None:
                raise Exception("No subtitles found in the video file.")
            return result
        else:
            raise ValueError(f"Unsupported extraction type: {self.extraction_type}")
