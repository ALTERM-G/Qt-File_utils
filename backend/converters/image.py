from PIL import Image
import os

def convert_image(input_path, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with Image.open(input_path) as img:
        if img.mode in ("RGBA", "LA") or (img.mode == "P" and "transparency" in img.info):
            img = img.convert("RGB")
        img.save(output_path)

    return output_path
