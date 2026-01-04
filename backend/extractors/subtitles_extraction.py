import subprocess
import os

def extract_subtitles(input_file, output_file):
    result = subprocess.run(
        ["ffprobe", "-v", "error", "-select_streams", "s", "-show_entries", "stream=index",
         "-of", "csv=p=0", input_file],
        capture_output=True,
        text=True
    )

    subtitle_streams = result.stdout.strip().splitlines()

    if not subtitle_streams or subtitle_streams == [""]:
        print("No subtitles found, skipping extraction")
        return None

    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    cmd = ["ffmpeg", "-i", input_file, "-map", "0:s", output_file]
    subprocess.run(cmd, check=True)

    return output_file
