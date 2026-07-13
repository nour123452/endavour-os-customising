# Building Endeavour OS Privacy Edition

Comprehensive guide to building the custom privacy-focused Endeavour OS ISO.

## Prerequisites

### System Requirements
- **OS**: Arch Linux or compatible (Ubuntu, Manjaro with AUR access)
- **CPU**: Multi-core processor
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 20GB free (for build files and ISO output)
- **Network**: Fast internet connection (1-2GB downloads)
- **Time**: 30-45 minutes for first build

### Package Requirements

```bash
# Install build dependencies
sudo pacman -S archiso syslinux edk2-shell grub

# Optional for faster builds
sudo pacman -S pigz  # Parallel gzip
```

## Step-by-Step Build

### 1. Clone Repository

```bash
git clone https://github.com/nourshery26-art/endavour-os-customising.git
cd endavour-os-customising
```

### 2. Verify Directory Structure

```bash
ls -la
# Should show:
# archiso/          - ISO build configuration
# packages/         - Package lists
# config/           - Configuration files
# scripts/          - Build and utility scripts
# docs/             - Documentation
```

### 3. Make Build Script Executable

```bash
chmod +x scripts/build-kde-iso.sh
```

### 4. Run Build Script

```bash
# Build as root
sudo ./scripts/build-kde-iso.sh
```

**Or manually with mkarchiso:**

```bash
cd archiso
sudo mkarchiso -v -o ../out .
```

### 5. Monitor Build Progress

The build will show:
- Downloading packages from Arch repositories
- Building filesystem
- Creating squashfs root image
- Creating ISO 9660 image
- Creating boot images

This typically takes 30-45 minutes on first run.

### 6. Verify Output

```bash
ls -lh out/
# Should show: endeavour-privacy-kde-*.iso (2.5-3GB)
```

## Customization

### Adding/Removing Packages

Edit package lists in `packages/`:

```bash
# Add package to specific category
echo "new-package" >> packages/privacy-tools.txt
```

Then rebuild ISO.

### Modifying Kernel Parameters

Edit `config/sysctl-hardening.conf` before building.

### Configuring Waterfox

Modify `config/waterfox-user.js` for different privacy settings.

### Changing Plymouth Theme

Edit `archiso/profiledef.sh` and `archiso/airootfs/etc/Plymouth` directories.

## Flashing to USB

### Find USB Device

```bash
lsblk
# or
sudo fdisk -l
```

**WARNING**: Make sure you select the correct device! Using the wrong device will erase that drive.

### Flash ISO

```bash
# Replace sdX with your device (e.g., sdb, sdc)
sudo dd if=out/endeavour-privacy-kde-*.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

### Alternative: Using Ventoy

[Ventoy](https://www.ventoy.net/) allows multiple ISOs on one USB:

```bash
# Install Ventoy to USB first
# Then copy ISO to USB's main partition
cp out/endeavour-privacy-kde-*.iso /mnt/ventoy/
```

## Testing Before Flashing

### Using QEMU

```bash
# Test in virtual machine
qemu-system-x86_64 \
  -m 4096 \
  -cdrom out/endeavour-privacy-kde-*.iso \
  -boot d
```

### Using VirtualBox

1. Create new VM
2. Set ISO as boot device
3. Allocate 4GB RAM, 20GB disk
4. Start and test

## Troubleshooting

### Build Fails with "Permission Denied"

```bash
# Run with sudo
sudo ./scripts/build-kde-iso.sh
```

### "mkarchiso not found"

```bash
# Install archiso
sudo pacman -S archiso
```

### Build Takes Too Long

- Normal: 30-45 minutes
- Slow internet? Check speed with `speedtest-cli`
- Low RAM? Close other applications

### ISO Size Too Large

If ISO > 3GB:

1. Remove packages from `packages/*.txt`
2. Clear package cache: `sudo pacman -Sc`
3. Rebuild

### "squashfs: compression failed"

Try with different compression:

Edit `archiso/profiledef.sh`:
```bash
compression="zstd"  # or gzip
```

## Post-Build

### Creating ISO Hash

```bash
sha256sum out/endeavour-privacy-kde-*.iso > out/SHA256SUMS
```

### Backup ISO

```bash
cp out/endeavour-privacy-kde-*.iso ~/backups/
```

### Distributing ISO

Include SHA256 hash for verification:

```bash
echo "ISO: $(ls out/endeavour-privacy-kde-*.iso)"
echo "Hash: $(sha256sum out/endeavour-privacy-kde-*.iso)"
```

## Advanced: Custom Branding

Modify these files for custom branding:

- `archiso/profiledef.sh` - ISO metadata
- `archiso/airootfs/etc/issue` - Boot message
- `archiso/efiboot/loader/entries/01-archiso-x86_64-linux.conf` - UEFI boot text

## Next Steps

1. **Test the ISO** in VM or on test hardware
2. **Flash to USB** using `dd` or Ventoy
3. **Boot from USB** on target machine
4. **Run post-installation script**: See `docs/FIRST_BOOT.md`

---

**Need help?** Check `docs/TROUBLESHOOTING.md` or open an issue on GitHub.
