import os
import subprocess


def compress_path_to_rar(input_path, output_path):
    if not os.path.exists(input_path):
        raise ValueError(f"Input path {input_path} is not a valid file or directory.")

    output_path = os.path.abspath(output_path)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    parent_dir = os.path.dirname(os.path.abspath(input_path))
    target_name = os.path.basename(input_path)

    if not parent_dir or parent_dir == input_path:
        parent_dir = os.getcwd()
        target_name = input_path

    cwd = os.getcwd()
    try:
        os.chdir(parent_dir)
        cmd = ['rar', 'a', '-r', output_path, target_name]
        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    except FileNotFoundError:
        raise FileNotFoundError(
            "The 'rar' command-line tool is not installed or not in your PATH. "
            "Please install it to create .rar archives."
        )
    except subprocess.CalledProcessError as e:
        error_message = e.stderr.decode('utf-8', errors='ignore').strip()
        raise subprocess.CalledProcessError(
            e.returncode, e.cmd, e.output,
            f"Error during RAR compression: {error_message}"
        ) from e
    finally:
        os.chdir(cwd)

    return output_path
