#!/bin/bash
# Endeavour OS Privacy Edition - KDE Plasma Build Script
# Builds minimal, privacy-focused ISO with WARP, MAC spoofing, and KDE Plasma

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check prerequisites
print_status "Checking prerequisites..."

if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root"
    exit 1
fi

if ! command -v archiso &> /dev/null; then
    print_error "archiso not installed. Install with: sudo pacman -S archiso"
    exit 1
fi

if ! command -v mkarchiso &> /dev/null; then
    print_error "mkarchiso not found. Install archiso: sudo pacman -S archiso"
    exit 1
fi

print_success "Prerequisites OK"

# Setup directories
BUILD_DIR="$(pwd)/archiso"
OUT_DIR="$(pwd)/out"
WORK_DIR="/tmp/archiso-work-$$"

print_status "Build directory: $BUILD_DIR"
print_status "Output directory: $OUT_DIR"

# Create output directory
mkdir -p "$OUT_DIR"

# Clean previous work
if [[ -d "$WORK_DIR" ]]; then
    print_status "Cleaning previous build..."
    rm -rf "$WORK_DIR"
fi

print_status "Starting ISO build..."
print_status "This may take 30-45 minutes"

# Build ISO
cd "$BUILD_DIR"

if mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" .; then
    print_success "ISO build completed!"
else
    print_error "ISO build failed"
    exit 1
fi

# Verify output
if ls "$OUT_DIR"/endeavour-privacy-kde-*.iso 1> /dev/null 2>&1; then
    ISO_FILE=$(ls "$OUT_DIR"/endeavour-privacy-kde-*.iso | head -1)
    ISO_SIZE=$(du -h "$ISO_FILE" | awk '{print $1}')
    print_success "ISO created: $ISO_FILE"
    print_success "Size: $ISO_SIZE"
    
    # Check size
    SIZE_MB=$(du -m "$ISO_FILE" | awk '{print $1}')
    if (( SIZE_MB <= 3000 )); then
        print_success "✓ Size within target (3GB max)"
    else
        print_status "⚠ Size is larger than expected (${SIZE_MB}MB > 3000MB)"
    fi
    
    print_status "\nFlash to USB with:"
    echo -e "${YELLOW}sudo dd if=$ISO_FILE of=/dev/sdX bs=4M status=progress${NC}"
    echo -e "${YELLOW}sudo sync${NC}"
    echo ""
    print_status "Replace 'sdX' with your USB device (e.g., sdb, sdc)"
    print_status "WARNING: This will erase the USB drive!"
else
    print_error "ISO file not found in output directory"
    exit 1
fi

# Cleanup
print_status "Cleaning up temporary files..."
rm -rf "$WORK_DIR"

print_success "Build complete!"
