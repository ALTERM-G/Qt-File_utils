import os
import subprocess

def extract_frames(input_file, output_folder, pattern="frame_%06d.png"):
    os.makedirs(output_folder, exist_ok=True)
    output_pattern = os.path.join(output_folder, pattern)

    cmd = ["ffmpeg", "-i", input_file, output_pattern]
    subprocess.run(cmd, check=True)

    return output_folder
