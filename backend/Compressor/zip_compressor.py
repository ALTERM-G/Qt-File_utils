import os
import zipfile


def compress_path_to_zip(input_path, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with zipfile.ZipFile(output_path, "w", compression=zipfile.ZIP_DEFLATED) as zipf:
        if os.path.isdir(input_path):
            for root, _, files in os.walk(input_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, os.path.dirname(input_path))
                    zipf.write(file_path, arcname)
        elif os.path.isfile(input_path):
            zipf.write(input_path, os.path.basename(input_path))
        else:
            raise ValueError(
                f"Input path {input_path} is not a valid file or directory."
            )

    return output_path
