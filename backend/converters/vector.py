import os
import subprocess
import shutil

SUPPORTED_INPUTS = {".pdf", ".svg"}
SUPPORTED_OUTPUTS = {".svg", ".pdf", ".png", ".eps"}

def convert_vector(input_path, output_path):
    if shutil.which("inkscape") is None:
        raise RuntimeError("Inkscape must be installed for vector conversions")

    in_ext = os.path.splitext(input_path)[1].lower()
    out_ext = os.path.splitext(output_path)[1].lower()

    if in_ext not in SUPPORTED_INPUTS:
        raise ValueError(f"Unsupported vector input: {in_ext}")

    if out_ext not in SUPPORTED_OUTPUTS:
        raise ValueError(f"Unsupported vector output: {out_ext}")

    # Inkscape command
    cmd = [
        "inkscape",
        input_path,
        "--export-filename=" + output_path,
    ]

    if out_ext == ".png":
        cmd += ["--export-dpi=600"]

    try:
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        raise RuntimeError("Vector conversion failed")

    return output_path
