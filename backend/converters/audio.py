import subprocess
import os

def convert_audio(input_path, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    cmd = ["ffmpeg", "-y", "-i", input_path, output_path]
    subprocess.run(cmd, check=True)

    return output_path
