import subprocess
import os

def extract_audio(input_path, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    ext = os.path.splitext(output_path)[1].lower()

    if ext == ".mp3":
        codec = "libmp3lame"
    elif ext == ".aac":
        codec = "aac"
    elif ext == ".wav":
        codec = "pcm_s16le"
    elif ext == ".flac":
        codec = "flac"
    elif ext == ".ogg":
        codec = "libvorbis"
    elif ext == ".opus":
        codec = "libopus"
    else:
        raise ValueError(f"Unsupported audio format: {ext}")

    cmd = ["ffmpeg", "-y", "-i", input_path, "-vn", "-acodec", codec, output_path]
    subprocess.run(cmd, check=True)

    return output_path
