# Advanced Image Optimization Script

A powerful Bash script for batch processing and optimizing images while maintaining quality and directory structure. Perfect for photographers, web developers, and content managers who need to process multiple images efficiently.

## Features

- Automatic image resizing with configurable maximum dimensions
- Smart optimization for different image formats:
  - JPEG/JPG optimization with quality preservation
  - PNG optimization with maximum compression
  - HEIC to JPEG conversion with optimization
- Directory structure preservation
- Detailed processing statistics
- Progress tracking for each file
- Compression ratio calculation

## Requirements

### Core Dependencies

- Bash 4.0+
- ImageMagick
- jpegoptim
- Either ECT or OptiPNG
- bc (basic calculator)

### Installation Guide

1. **Install core system packages:**

   For Debian/Ubuntu:
   ```bash
   sudo apt update
   sudo apt install imagemagick jpegoptim bc
   ```

   For macOS (using Homebrew):
   ```bash
   brew install imagemagick jpegoptim bc
   ```

   For CentOS/RHEL:
   ```bash
   sudo yum install ImageMagick jpegoptim bc
   ```

2. **Install PNG optimizer (choose one):**

   ECT (Efficient Compression Tool):
   ```bash

   # Build from source
   git clone https://github.com/fhanau/Efficient-Compression-Tool.git
   cd Efficient-Compression-Tool
   make
   sudo make install
   ```

   OptiPNG:
   ```bash
   # Ubuntu/Debian
   sudo apt install optipng

   # macOS
   brew install optipng

   # CentOS/RHEL
   sudo yum install optipng
   ```

3. **Install the script:**

   ```bash
   # Clone the repository
   git clone https://github.com/pervak/batch-image-resizer.git
   cd batch-image-resizer

   # Make the script executable
   chmod +x image_resizer_single_cpu.sh

   # Optional: make it available system-wide
   sudo ln -s "$(pwd)/image_resizer_single_cpu.sh" /usr/local/bin/image_resizer_single_cpu
   ```

## Usage

Basic usage:
```bash
./image_resizer_single_cpu.sh <source_directory> <destination_directory>
```

Example:
```bash
./image_resizer_single_cpu.sh ~/Pictures/Original ~/Pictures/Optimized
```

## Configuration

The script includes several configurable parameters at the beginning:

```bash
# Target maximum dimension for image resizing
MAX_DIMENSION=2000

# JPEG optimization quality (0-100)
JPEG_QUALITY=90

# PNG optimization level
PNG_OPTIMIZATION_LEVEL=7
```

Modify these values in the script according to your needs.

## Supported File Types

- JPEG/JPG
- PNG
- HEIC

## Output Information

For each processed image, the script provides:
- Original dimensions
- Original file size
- Processing steps applied
- Final file size
- Compression ratio
- Overall compression percentage

## Known Limitations

- HEIC files are converted to JPEG
- Processing speed depends on hardware and image sizes
- Some image metadata may be stripped during optimization

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

This script utilizes several open-source tools:
- ImageMagick: https://imagemagick.org
- jpegoptim: https://github.com/tjko/jpegoptim
- ECT: https://github.com/fhanau/Efficient-Compression-Tool
- OptiPNG: http://optipng.sourceforge.net

## Support

If you encounter any issues or have questions, please create an issue in the repository.

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x image_resizer_single_cpu.sh
   ```

2. **Missing Dependencies**
   Check if all required tools are installed:
   ```bash
   command -v magick jpegoptim bc >/dev/null || echo "Missing dependencies"
   ```

3. **ImageMagick Policy Restrictions**
   If you encounter ImageMagick permission issues, you may need to update the policy file:
   ```bash
   sudo nano /etc/ImageMagick-6/policy.xml
   # or
   sudo nano /etc/ImageMagick-7/policy.xml
   ```

### Performance Tips

- For large batches of images, use ECT with multi-threading
- Process smaller batches if memory usage is high
- Consider using SSD storage for faster processing

## Future Development

Planned features:
- Parallel processing for multiple images
- Progress bar for large batches
- Dry run option
- Backup option for original files
