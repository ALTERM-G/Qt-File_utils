import subprocess
import os

def extract_frames(input_path, output_dir, pattern="frame_%06d.png"):
    os.makedirs(output_dir, exist_ok=True)

    cmd = ["ffmpeg", "-y", "-i", input_path, os.path.join(output_dir, pattern)]
    subprocess.run(cmd, check=True)

    return output_dir
