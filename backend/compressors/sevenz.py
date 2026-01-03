import os
import py7zr


def compress_path_to_7z(input_path, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with py7zr.SevenZipFile(output_path, "w") as archive:
        if os.path.isdir(input_path):
            archive.writeall(
                input_path,
                arcname=os.path.basename(input_path)
            )

        elif os.path.isfile(input_path):
            archive.write(
                input_path,
                arcname=os.path.basename(input_path)
            )

        else:
            raise ValueError(
                f"Input path {input_path} is not a valid file or directory."
            )

    return output_path
