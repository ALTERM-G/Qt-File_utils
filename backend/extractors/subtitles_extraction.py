import subprocess
import os

def extract_subtitles(input_path, output_dir, pattern="subtitle_%02d.srt"):
    os.makedirs(output_dir, exist_ok=True)

    cmd = ["ffmpeg", "-y", "-i", input_path, "-map", "0:s", os.path.join(output_dir, pattern)]
    subprocess.run(cmd, check=True)

    return output_dir
