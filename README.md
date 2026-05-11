# img_to_text

Extracts text from images using Tesseract OCR. Available as a Python script and a shell script — both produce identical output.

For each image, a subfolder is created named after the image, and the extracted text is saved as a `.txt` file inside it.

**Example:**
```
images/
  invoice.png       →   images/invoice/invoice.txt
  receipt.jpg       →   images/receipt/receipt.txt
```

Supported formats: `.png`, `.jpg`, `.jpeg`, `.bmp`, `.tiff`, `.tif`

---

## Shell script (`img_to_text.sh`)

No Python required. Only needs `tesseract` installed.

### Requirements

- bash
- [tesseract](https://github.com/tesseract-ocr/tesseract)

```bash
# macOS
brew install tesseract

# Ubuntu / Debian
sudo apt install tesseract-ocr
```

### Usage

```bash
# make executable (first time only)
chmod +x img_to_text.sh

# run on default ./images folder
./img_to_text.sh

# run on a custom folder
./img_to_text.sh /path/to/folder
```

---

## Python script (`img_to_text.py`)

### Requirements

- Python 3.7+
- tesseract (same install as above)
- `pytesseract` Python package

```bash
pip install pytesseract
```

### Usage

```bash
# run on default ./images folder
python img_to_text.py

# run on a custom folder
python img_to_text.py /path/to/folder
```

---

## Output structure

```
<folder>/
  <image_name>/
    <image_name>.txt
```
