#!/bin/bash
# (c) Alex Pervak, 2025

# Source and destination directories, put this as command-line parameters
SRC_DIR="$1"
DEST_DIR="$2"

# Target maximum dimension
MAX_DIMENSION=2000

# Initialize order counter
ORDER_NUMBER=0

# Check if source and destination directories are provided
if [ -z "$SRC_DIR" ] || [ -z "$DEST_DIR" ]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Function to calculate file size in bytes
get_file_size() {
  stat -f%z "$1" 2>/dev/null
}

# Function to calculate compression level
calculate_compression() {
  local original_size="$1"
  local compressed_size="$2"
  local compression_ratio=$(echo "scale=2; $compressed_size / $original_size" | bc)
  local compression_percentage=$(echo "scale=2; (1 - $compression_ratio) * 100" | bc)
  echo "[$3] Compression: ${compression_percentage}% (Ratio: ${compression_ratio})"
}

# Check if ECT is installed
# ECT is more efficient than OptiPNG, preferrable tool
# Download and install from https://github.com/fhanau/Efficient-Compression-Tool
if command -v ect >/dev/null 2>&1; then
  PNG_OPTIMIZER="ect -9 --mt-deflate"
else
  PNG_OPTIMIZER="optipng -o7 -quiet -strip all"
fi

# Function to process images
process_image() {
  ((ORDER_NUMBER++))
  local src_file="$1"
  local dest_file="$2"
  local original_size=$(get_file_size "$src_file")

  # Get source original dimensions
  dimensions=$(magick identify -format "%wx%h" "$src_file")
  width=$(echo $dimensions | cut -d'x' -f1)
  height=$(echo $dimensions | cut -d'x' -f2)

  echo "[$ORDER_NUMBER] Processing: '$src_file' -> '$dest_file'"
  echo "[$ORDER_NUMBER] Original size: $original_size bytes"
  echo "[$ORDER_NUMBER] Dimensions: ${width}x${height}"

  # Check if resizing is needed
  if (( width > MAX_DIMENSION || height > MAX_DIMENSION )); then
    echo "[$ORDER_NUMBER] Resizing to max ${MAX_DIMENSION}px"
    magick "$src_file" -resize "${MAX_DIMENSION}x${MAX_DIMENSION}>" "$dest_file"
  else
    echo "[$ORDER_NUMBER] Keeping original dimensions"
    cp -f "$src_file" "$dest_file"
  fi

  # Optimize based on file type
  case "${src_file##*.}" in
    jpg|jpeg)
      echo "[$ORDER_NUMBER] Optimizing JPEG"
      jpegoptim --max=90 --strip-all --quiet "$dest_file"
      ;;
    png)
      echo "[$ORDER_NUMBER] Optimizing PNG"
      $PNG_OPTIMIZER "$dest_file"
      ;;
    heic)
      # Convert HEIC to JPEG
      jpeg_dest="${dest_file%.heic}.jpg"
      echo "[$ORDER_NUMBER] Converting HEIC to JPEG"
      magick "$dest_file" "$jpeg_dest"
      echo "[$ORDER_NUMBER] Optimizing JPEG"
      jpegoptim --max=90 --strip-all --quiet "$jpeg_dest"
      rm "$dest_file"
      dest_file="$jpeg_dest"
      ;;
    *)
      echo "[$ORDER_NUMBER] Unsupported file type"
      return
      ;;
  esac

  # Calculate compression stats
  compressed_size=$(get_file_size "$dest_file")
  echo "[$ORDER_NUMBER] Compressed size: $compressed_size bytes"
  calculate_compression "$original_size" "$compressed_size" "$ORDER_NUMBER"
  echo ""
}

# Main processing loop
find "$SRC_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.heic" \) -print0 | while IFS= read -r -d '' src_file; do
  # Create destination path
  relative_path="${src_file#$SRC_DIR}"
  dest_file="$DEST_DIR${relative_path}"
  dest_dir=$(dirname "$dest_file")

  # Create destination directory if needed
  mkdir -p "$dest_dir"

  # Process the file
  process_image "$src_file" "$dest_file"
done

echo "All images processed successfully! Total files: $ORDER_NUMBER"
echo "---====!BE HAPPY!====---"
