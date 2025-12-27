import subprocess
import os

def convert_video(input_path: str, output_path: str):
    import subprocess
    cmd = ["ffmpeg", "-y", "-i", input_path, output_path]
    subprocess.run(cmd, check=True)
    return output_path
