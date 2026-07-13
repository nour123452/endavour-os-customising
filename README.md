# Endeavour OS Privacy Edition 🔐

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![ISO Size](https://img.shields.io/badge/ISO%20Size-2.5--3GB-brightgreen)](#size-target)
[![USB Size](https://img.shields.io/badge/USB%20Requirement-8GB%2B-brightgreen)](#prerequisites)

A **privacy-focused, minimalist Arch-based ISO** with **KDE Plasma**, **Cloudflare WARP**, **automatic MAC spoofing**, and the **Arasaka Plymouth** boot theme.

## Features ✨

### Privacy & Security
- 🌐 **Cloudflare WARP** - Fast, encrypted privacy VPN (not Tor)
- 🔀 **Auto MAC Spoofing** - Randomizes MAC on every network change
- 🔒 **Kernel Hardening** - ASLR, DEP, ptrace restrictions, SYSRq disabled
- 🧅 **DNS Privacy** - dnscrypt-proxy with DoH/DoT
- 🚫 **No Telemetry** - All tracking disabled
- 🔧 **UFW Firewall** - Default-deny incoming, encrypted outgoing
- 💾 **Stateless by Default** - Nothing persisted (like Tails)
- 🌍 **IP Refresh Utility** - Easy `refresh-ip` command for new IP

### System & Desktop
- ✨ **KDE Plasma 6** - Beautiful, powerful desktop environment
- 🎨 **Arasaka Plymouth** - Cyberpunk boot theme
- 🚀 **Lightweight** - 2.5-3GB ISO (fits 8GB USB)
- 🏗️ **Arch-based** - Full AUR + official repos access
- ⚡ **Fast** - Hardened Linux kernel for performance

### Included Tools
- 🌐 **Waterfox** - Privacy-first browser (no telemetry)
- 🔐 **KeePass2** - Password manager
- 💌 **Thunderbird** - Encrypted email (OpenPGP)
- 💬 **Jami** - Secure peer-to-peer messaging
- 🎬 **VLC** - Lightweight media player
- 🎨 **Spectacle** - Screenshot tool
- 📄 **Okular** - PDF viewer
- 📁 **Dolphin** - File manager

## Quick Start 🚀

### Prerequisites

- **Build Machine**: Arch Linux or compatible (5GB free disk)
- **Flashing**: 8GB+ USB drive
- **Time**: 30-45 minutes for first build

### Build ISO

```bash
# Clone repository
git clone https://github.com/nourshery26-art/endavour-os-customising.git
cd endavour-os-customising

# Install build tools
sudo pacman -S archiso syslinux edk2-shell

# Build ISO
sudo ./scripts/build-kde-iso.sh

# Wait 30-45 minutes...
# Output: out/endeavour-privacy-kde-*.iso (~2.5-3GB)
```

### Flash to USB

```bash
# Find USB device
lsblk

# Flash (replace sdX with your device, e.g., sdb)
sudo dd if=out/endeavour-privacy-kde-*.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

### First Boot

1. **Boot from USB** → See Arasaka Plymouth theme
2. **Login with KDE Plasma** → Automatic privacy setup
3. **Privacy services start automatically**:
   - Cloudflare WARP connects
   - MAC spoofing active
   - UFW firewall enabled
   - DNS privacy via dnscrypt-proxy

## Size & Specs

```
┌──────────────────────────────────────┐
│ Endeavour OS Privacy Edition Specs    │
├──────────────────────────────────────┤
│ ISO Size:         2.5-3GB            │
│ USB Required:     8GB minimum         │
│ USB Free Space:   5-5.5GB             │
│ Build Time:       30-45 minutes       │
│ RAM Required:     4GB (8GB+ better)   │
│ Disk Free:        20GB for building   │
└──────────────────────────────────────┘
```

## Key Commands

### Refresh IP Address

```bash
# Attempt to get new public IP (ISP dependent)
sudo refresh-ip

# Or specify interface
sudo refresh-ip wlan0
```

### Manage Cloudflare WARP

```bash
# First time setup
warp-cli registration new

# Connect to WARP
warp-cli connect

# Check connection status
warp-cli status

# Disconnect
warp-cli disconnect
```

### Check Privacy Settings

```bash
# View firewall rules
sudo ufw status verbose

# Check DNS privacy
sudo systemctl status dnscrypt-proxy

# View MAC address
ip link show

# Check public IP
curl https://api.ipify.org
```

## System Architecture

```
┌─────────────────────────────────────────┐
│      User Applications                  │
│  (Waterfox, KeePass, Jami, etc.)       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│   KDE Plasma 6 Desktop Environment      │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  Network Layer                          │
│  ├─ Cloudflare WARP (Privacy VPN)       │
│  ├─ dnscrypt-proxy (DNS Privacy)        │
│  └─ UFW Firewall (Default Deny)         │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  MAC Spoofing Layer (Auto)              │
│  └─ macchanger (Randomize per network)  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  Kernel (linux-hardened)                │
│  ├─ ASLR / DEP / NX enabled             │
│  ├─ ptrace restrictions                 │
│  ├─ kexec disabled                      │
│  └─ SysRq disabled                      │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│      ISP / Network / Internet           │
└───────���─────────────────────────────────┘
```

## Privacy vs Other Systems

| Feature | Tails | Tor Browser | This Build |
|---------|-------|-------------|------------|
| **Base** | Debian | Chromium | Arch |
| **Desktop** | GNOME | Minimal | KDE Plasma ✨ |
| **Privacy Transport** | Tor | Tor | WARP ⚡ |
| **Speed** | Slow | Medium | Fast |
| **MAC Spoofing** | Manual | No | Auto ✓ |
| **Size** | 1.4GB | ~400MB | 2.5-3GB |
| **Customization** | Limited | N/A | Full AUR ✓ |
| **Anonymity Level** | Max (Tor) | High (Tor) | High (WARP) |
| **Use Case** | Max privacy | Anonymous browsing | Daily driver |

## Documentation

- 📖 [**BUILDING.md**](docs/BUILDING.md) - Detailed build instructions
- 🔐 [**PRIVACY_FEATURES.md**](docs/PRIVACY_FEATURES.md) - Privacy explained
- 🔧 [**KDE_PRIVACY_BUILD.md**](KDE_PRIVACY_BUILD.md) - Architecture & customization

## Directory Structure

```
.
├── README.md                    # This file
├── KDE_PRIVACY_BUILD.md         # Build architecture
├── scripts/
│   ├── build-kde-iso.sh        # Main build script
│   ├── refresh-ip.sh           # IP refresh utility
│   └── validate-size.sh        # Size validator
├── archiso/
│   ├── profiledef.sh           # ISO configuration
│   ├── pacman.conf             # Package manager config
│   ├── airootfs/
│   │   ├── etc/                # System configs
│   │   ├── usr/bin/            # Custom scripts
│   │   └── root/               # Build customization
│   └── efiboot/
├── packages/
│   ├── base.txt                # Essential packages
│   ├── kde-plasma.txt          # KDE Plasma
│   ├── privacy-tools.txt       # Privacy utilities
│   └── network.txt             # Network tools
├── config/
│   ├── sysctl-hardening.conf  # Kernel hardening
│   ├── dnscrypt-proxy.toml    # DNS privacy
│   ├── ufw-rules.sh           # Firewall rules
│   ├── waterfox-user.js       # Browser hardening
│   └── plasmarc                # KDE defaults
├── hooks/
│   └── post-install.sh         # Post-install setup
└── docs/
    ├── BUILDING.md             # Build guide
    ├── PRIVACY_FEATURES.md     # Privacy explained
    └── TROUBLESHOOTING.md      # Common issues
```

## Customization

### Add Packages

```bash
# Edit package list
nano packages/privacy-tools.txt

# Add your package
echo "my-package" >> packages/privacy-tools.txt

# Rebuild
sudo ./scripts/build-kde-iso.sh
```

### Change Privacy Settings

- **Kernel hardening**: `config/sysctl-hardening.conf`
- **Firewall rules**: `config/ufw-rules.sh`
- **Browser settings**: `config/waterfox-user.js`
- **DNS providers**: `config/dnscrypt-proxy.toml`

## Troubleshooting

### Build Fails

```bash
# Verify archiso installed
sudo pacman -S archiso

# Check disk space
df -h /

# Run with verbose output
sudo ./scripts/build-kde-iso.sh -v
```

### ISO Too Large

```bash
# Remove packages from packages/*.txt
# Clear cache
sudo pacman -Sc

# Rebuild
sudo ./scripts/build-kde-iso.sh
```

### USB Not Detected

```bash
# List devices
lsblk -d

# Or with more detail
sudo fdisk -l
```

See **[TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** for more.

## Testing Before Flashing

### In QEMU

```bash
qemu-system-x86_64 -m 4096 -cdrom out/endeavour-privacy-kde-*.iso
```

### In VirtualBox

1. Create new VM
2. Mount ISO as boot device
3. Allocate 4GB RAM
4. Start and test

## Security Notes ⚠️

1. **Trust the build machine** - Use clean, trusted system
2. **Verify downloads** - Check SHA256 after building
3. **No system is 100% secure** - This is very good, not perfect
4. **WARP is not Tor** - Less anonymous but faster
5. **Keep updated** - Rebuild regularly for latest patches
6. **Don't rely solely on MAC spoofing** - Use with WARP

## Contributing

Fork, improve, and send PRs! Areas for contribution:

- 🐛 Bug fixes
- 📦 Package optimization
- 🎨 Plymouth theme improvements
- 📚 Documentation
- 🔐 Security hardening
- ⚡ Performance optimization

## License

GPL v3 - See LICENSE file

## Resources

- [Endeavour OS](https://endeavousos.com/)
- [Arch Linux](https://archlinux.org/)
- [Cloudflare WARP](https://1.1.1.1/)
- [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy)
- [Waterfox](https://www.waterfox.net/)
- [Arasaka Plymouth](https://gitlab.com/pSchwietzer/arasaka-plymouth)
- [KDE Plasma](https://kde.org/plasma/)

## Support

- 📖 Check documentation in `docs/`
- 🐛 Open an issue for bugs
- 💡 Submit PRs for improvements
- 💬 Discuss in GitHub Discussions

---

**⚠️ Disclaimer**: This is an educational project. While privacy features are implemented, no system is 100% secure. Use responsibly.

**Made with ❤️ for privacy** 🔒
