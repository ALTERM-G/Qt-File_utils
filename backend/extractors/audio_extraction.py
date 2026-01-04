import subprocess
import os

def extract_audio(input_path, output_path):
    output_dir = os.path.dirname(output_path)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)

    cmd = ["ffmpeg", "-y", "-i", input_path, "-vn", "-acodec", "copy", output_path]
    subprocess.run(cmd, check=True)

    return output_path
