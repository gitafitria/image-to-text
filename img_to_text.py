import pytesseract
import concurrent.futures
from pathlib import Path
import sys

IMAGE_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.bmp', '.tiff', '.tif'}


def process_image(img_path):
    output_dir = img_path.parent / img_path.stem
    output_dir.mkdir(exist_ok=True)

    text = pytesseract.image_to_string(str(img_path), lang='eng')

    output_file = output_dir / f"{img_path.stem}.txt"
    output_file.write_text(text, encoding='utf-8')

    print(f"[done] {img_path.name} -> {output_file}")


def main():
    folder = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('images')

    if not folder.is_dir():
        print(f"[error] folder not found: {folder}")
        sys.exit(1)

    img_paths = [p for p in folder.iterdir() if p.suffix.lower() in IMAGE_EXTENSIONS]

    if not img_paths:
        print(f"[error] no images found in {folder}")
        sys.exit(1)

    print(f"found {len(img_paths)} image(s) in {folder}")

    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = {executor.submit(process_image, p): p for p in img_paths}
        for future in concurrent.futures.as_completed(futures):
            path = futures[future]
            try:
                future.result()
            except Exception as e:
                print(f"[error] {path.name}: {e}")


if __name__ == "__main__":
    main()
