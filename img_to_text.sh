#!/usr/bin/env bash
set -uo pipefail

FOLDER="${1:-images}"

if [ ! -d "$FOLDER" ]; then
    echo "[error] folder not found: $FOLDER"
    exit 1
fi

if ! command -v tesseract &>/dev/null; then
    echo "[error] tesseract not found. Install with: brew install tesseract"
    exit 1
fi

process_image() {
    local img_path="$1"
    local img_name img_stem img_dir output_dir
    img_name="$(basename "$img_path")"
    img_stem="${img_name%.*}"
    img_dir="$(dirname "$img_path")"
    output_dir="$img_dir/$img_stem"

    mkdir -p "$output_dir"
    if tesseract "$img_path" "$output_dir/$img_stem" -l eng 2>/dev/null; then
        echo "[done] $img_name -> $output_dir/$img_stem.txt"
    else
        echo "[error] $img_name: tesseract failed"
    fi
}

img_paths=()
while IFS= read -r -d '' f; do
    img_paths+=("$f")
done < <(find "$FOLDER" -maxdepth 1 -type f \( \
    -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \
    -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.tif" \
\) -print0)

if [ ${#img_paths[@]} -eq 0 ]; then
    echo "[error] no images found in $FOLDER"
    exit 1
fi

echo "found ${#img_paths[@]} image(s) in $FOLDER"

for img_path in "${img_paths[@]}"; do
    process_image "$img_path" &
done

wait
