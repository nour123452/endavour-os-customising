# Endeavour OS Privacy Edition - KDE Plasma Build

A **privacy-focused Arch-based ISO** optimized for 8GB USB with **Cloudflare WARP**, **automatic MAC spoofing**, and **KDE Plasma** desktop.

## Size Target: ~2.5-3GB (still fits 8GB USB comfortably)

### Build Strategy

```
Tails size:        ~1.4GB
This edition:      ~2.5-3GB (KDE Plasma adds ~800MB)
USB free space:    ~5-5.5GB for user data
```

## Core Components

### Privacy Stack (NO TOR)
- **Cloudflare WARP** - Privacy DNS + VPN (faster than Tor, still private)
- **MAC Address Changer** - Auto-randomize on network switch
- **dnscrypt-proxy** - DoH/DoT for DNS privacy
- **UFW Firewall** - Default deny incoming
- **Kernel hardening** - ASLR, DEP, ptrace restrictions

### Desktop Environment
- **KDE Plasma 6** - Modern, feature-rich, highly customizable
- **Breeze Dark Theme** - Sleek, dark interface
- **KDE Frameworks** - Full productivity suite

### Essential Privacy Tools
```
✓ Cloudflare WARP (auto-connect)
✓ MAC spoofer (auto-randomize per network)
✓ dnscrypt-proxy
✓ KeePass2 (password manager)
✓ Thunderbird + EnigMail (encrypted email)
✓ Jami/Tox (secure chat)
✓ VLC (minimal media player)
✓ Waterfox (privacy-focused browser)
✓ Spectacle (screenshot tool)
✓ Konsole (terminal)
```

## Minimal Package List (~400 packages)

```
# Base System: ~150MB
base linux-hardened linux-firmware mkinitcpio

# KDE Plasma: ~800MB (compressed)
plasma-desktop
plasma-nm (network manager)
plasma-pa (audio)
sddm (login manager)
breeze breeze-icons
plasma-workspace-wallpapers

# Privacy & Network: ~250MB
cloudflare-warp
macchanger
dnscrypt-proxy
ufw
openssh

# Essential Apps: ~300MB
waterfox-bin
thunderbird
keepass
jami
vlc
spectacle
okular (PDF viewer)
dolphin (file manager - included with Plasma)
konsole

# Utilities: ~200MB
coreutils util-linux e2fsprogs parted
curl wget networkmanager
grep sed awk findutils
gzip bzip2 xz

# Development: ~100MB (minimal)
nano vim
git (optional, can remove to save space)
```

**Total uncompressed**: ~4-4.5GB  
**After XZ compression**: ~2.5-3GB

## Waterfox Browser

**Why Waterfox over Firefox?**
- Purpose-built for privacy (removes telemetry, pocket, studies)
- No Mozilla account requirement
- Available in standard and G6 variants
- Uses `waterfox-bin` from AUR (pre-compiled)
- Smaller footprint than Firefox
- Hardened privacy by default

**Pre-configured in build:**
```
~/.config/waterfox/profiles.ini
~/.waterfox/defaults/pref/custom.js

Includes:
- uBlock Origin
- Privacy Badger
- HTTPS Everywhere
- No telemetry
- Enhanced tracking protection
- DoH configured
```

## Key Features

### 1. Cloudflare WARP Integration

**`archiso/airootfs/etc/warp-setup.sh`:**
```bash
#!/bin/bash
# Auto-configure Cloudflare WARP

sudo pacman -S --noconfirm cloudflare-warp

# Enable WARP service
sudo systemctl enable warp-svc
sudo systemctl start warp-svc

# Register (user can do manually first time)
warp-cli registration new

# Set to auto-connect
warp-cli connect

echo "Cloudflare WARP configured and running"
```

### 2. Automatic MAC Address Spoofing

**`archiso/airootfs/etc/systemd/system/macspoof@.service`:**
```ini
[Unit]
Description=MAC Address Spoofer for %i
After=network-pre.target
Before=network.target
ConditionVirtualization=!container

[Service]
Type=oneshot
ExecStart=/usr/bin/macchanger -r %i
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**`archiso/airootfs/etc/udev/rules.d/99-macspoof.rules`:**
```
# Auto-spoof MAC on every interface change
ACTION=="add", SUBSYSTEM=="net", RUN+="/usr/bin/systemctl start macspoof@%k.service"
```

**`archiso/airootfs/usr/bin/macspoof-monitor.sh`:**
```bash
#!/bin/bash
# Monitor network changes and randomize MAC

while inotifywait -e modify /sys/class/net/*/address; do
    for iface in $(ip link show | grep "^[0-9]" | awk '{print $2}' | tr -d ':'); do
        if [[ "$iface" != "lo" ]]; then
            sudo macchanger -r "$iface" 2>/dev/null
            echo "MAC randomized on $iface"
        fi
    done
done
```

Enable on startup via systemd user service.

### 3. KDE Plasma Customization

**`archiso/airootfs/etc/skel/.config/plasmarc`:**
```ini
[General]
Session=plasmawayland

[Theme]
name=breeze-dark

[Wallpaper]
wallpaper=Endorsement
```

**Waterfox hardened by default:**
- Privacy-first configuration
- uBlock Origin + Privacy Badger preconfigured
- HTTPS-Only mode enabled
- No telemetry/tracking
- Fingerprint protection enabled

## Directory Structure

```
.
├── README.md
├── MINIMALIST_BUILD.md          # Old version (for reference)
├── KDE_PRIVACY_BUILD.md         # This file
├── scripts/
│   ├── build-kde-iso.sh         # Main build script
│   ├── setup-warp.sh            # WARP configuration
│   ├── setup-macspoof.sh        # MAC spoofing setup
│   └── validate-size.sh
├── archiso/
│   ├── profiledef.sh
│   ├── airootfs/
│   │   ├── etc/
│   │   │   ├── sysctl.d/        # Kernel hardening
│   │   │   ├── security/
│   │   │   ├── ufw/             # Firewall rules
│   │   │   ├── dnscrypt-proxy/  # DNS privacy
│   │   │   ├── warp-setup.sh    # WARP init
│   │   │   └── udev/rules.d/    # MAC spoof rules
│   │   ├── usr/
│   │   │   ├── bin/
│   │   │   │   └── macspoof-monitor.sh
│   │   │   └── local/
│   │   ├── root/                # Build customization
│   │   └── etc/skel/            # User defaults (KDE config)
│   └── efiboot/
├── packages/
│   ├── base.txt
│   ├── kde-plasma.txt
│   ├── privacy-tools.txt
│   └── network.txt
├── config/
│   ├── sysctl-hardening.conf
│   ├── dnscrypt-proxy.conf
│   ├── ufw-rules.sh
│   ├── plasmarc                 # KDE defaults
│   └── waterfox-prefs.js        # Waterfox hardening
├── hooks/
│   ├── post-install.sh
│   └── warp-first-run.sh
└── docs/
    ├── BUILDING.md
    ├── PRIVACY_FEATURES.md
    └── TROUBLESHOOTING.md
```

## Size Breakdown (Estimated)

```
Component              Uncompressed  Compressed
────────────────────────────────────────────
Kernel + modules       ~200MB        ~40MB
Base system            ~600MB        ~150MB
KDE Plasma + deps      ~1,000MB      ~350MB
Privacy tools          ~300MB        ~100MB
Waterfox + plugins     ~500MB        ~180MB
Applications           ~150MB        ~50MB
Wallpapers/themes      ~150MB        ~40MB
────────────────────────────────────────────
Total                  ~4,350MB      ~910MB

Squashfs (XZ -9)       ~910MB        ~2.5-2.8GB
ISO overhead           ~20MB
────────────────────────────────────────────
Final ISO Size         ~2.5-3GB ✓
```

## Build Configuration

**`archiso/profiledef.sh`:**
```bash
#!/usr/bin/env bash
# archiso profile configuration

iso_name="endeavour-privacy-kde"
iso_label="ENDEAVOUR_KDE"
iso_application="Endeavour OS Privacy Edition with KDE Plasma & Waterfox"
iso_version="2024.1"
install_dir="arch"
bootmodes=('uefi' 'bios.syslinux.mbr')
arch="x86_64"
pacman_conf="pacman.conf"
sourcedate_epoch=$(date +%s)

# Maximum compression
compression="xz"
compression_options="-9 -Xbcj x86 -Xdict-size=1MiB"

# buildmodes: netinstall, iso, all
buildmodes=('iso')

# Grub menu
grub_preset_cfg="grub_preset.cfg"
```

## Package Lists

### `packages/kde-plasma.txt`
```
# Display server & WM
xorg-server
plasma-desktop
sddm
kdeconnect
kscreen

# KDE Frameworks & Applications
breeze
breeze-icons
breeze-gtk
kdeclarative
kdeclarative5
kdeclarative-dev
plasma-framework
kconfig
kcoreaddons
kdbusaddons
kdeclarative
kded
kdelibs4support
kdoctools
plasma-workspace
plasma-workspace-wallpapers
plasma-pa
plasma-nm
plasma-firewall

# KDE Apps
dolphin
konsole
okular
spectacle
kcharselect
kcalc
```

### `packages/privacy-tools.txt`
```
# Cloudflare WARP
cloudflare-warp

# MAC Spoofing
macchanger
inotify-tools

# DNS Privacy
dnscrypt-proxy

# Firewall
ufw

# Browser
waterfox-bin

# Core Privacy
openssh
curl
wget

# Essential Apps
thunderbird
keepass
jami
vlc
```

## Build Instructions

```bash
# 1. Clone repo
git clone https://github.com/nourshery26-art/endavour-os-customising.git
cd endavour-os-customising

# 2. Install dependencies
sudo pacman -S archiso syslinux edk2-shell

# 3. Build ISO
./scripts/build-kde-iso.sh

# 4. Verify size (should be 2.5-3GB)
ls -lh out/endeavour-privacy-kde-*.iso

# 5. Flash to 8GB USB
sudo dd if=out/endeavour-privacy-kde-*.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

## First Boot Experience

1. **Boot screen**: Arasaka Plymouth theme
2. **Login**: SDDM with KDE Plasma
3. **Auto-services on startup**:
   - Cloudflare WARP connects automatically
   - MAC address randomization active
   - UFW firewall enabled
   - DNS privacy (dnscrypt-proxy) active

4. **User experience**: Full KDE Plasma with Waterfox and all privacy features transparent

## Privacy Features Explained

### Cloudflare WARP vs Tor
```
Tor                      Cloudflare WARP
─────────────────────────────────────────
Slower (multi-hop)       Faster (direct)
Strong anonymity         Privacy-focused (not anonymous)
Blocks many sites        Works with all sites
More setup needed        Auto-connect, no setup
Free                     Free (with WARP+ option)
Perfect for privacy      Great for privacy + speed balance
```

### MAC Address Spoofing
- **Randomizes on every network connection**
- Prevents device tracking across networks
- Works automatically, invisible to user

### Waterfox Browser
- **Privacy-first defaults** (telemetry removed at source)
- **Lighter than Firefox** while maintaining full extension support
- **Fingerprint resistance** built-in
- **No mandatory accounts** or data collection
- **Extended support** for privacy extensions (uBlock Origin, Privacy Badger, etc.)

### Kernel Hardening
```
sysctls enabled:
- kernel.unprivileged_userns_clone=0
- kernel.kptr_restrict=2
- kernel.dmesg_restrict=1
- kernel.printk=3
- kernel.unprivileged_bpf_disabled=1
- kernel.yama.ptrace_scope=3
- net.ipv4.ip_forward=0
- net.ipv6.conf.all.forwarding=0
```

## Comparison Table

| Feature | Tails | Tor Browser | This Build |
|---------|-------|-------------|-----------|
| **Base** | Debian | Chromium | Arch Linux |
| **Privacy Transport** | Tor | Tor | Cloudflare WARP |
| **Browser** | Firefox ESR | Tor Browser | Waterfox |
| **Speed** | Slow | Medium | Fast ⚡ |
| **Desktop** | GNOME | Minimal | KDE Plasma ✨ |
| **Size** | 1.4GB | ~400MB | 2.5-3GB |
| **MAC Spoofing** | Manual | No | Auto ✓ |
| **Customization** | Limited | N/A | Full AUR ✓ |
| **Privacy Level** | Maximum (Tor) | High (Tor) | High (WARP) |
| **Use Case** | Max anonymity | Browse anonymously | Privacy + functionality |

## Network Behavior

```
User connects to WiFi
    ↓
UDEV rule triggers
    ↓
macchanger randomizes MAC
    ↓
Systemd brings up interface
    ↓
NetworkManager connects
    ↓
Cloudflare WARP intercepts DNS
    ↓
dnscrypt-proxy provides DoH/DoT
    ↓
UFW firewall applies rules
    ↓
Traffic flows through WARP
    ↓
Waterfox with hardened privacy settings
    ↓
Complete privacy, no tracking
```

## What's NOT Included

- ❌ Tor (using WARP instead)
- ❌ Persistence mode (stateless by default)
- ❌ Printers/Bluetooth (can add if needed)
- ❌ Development tools (keep it light)
- ❌ Multimedia codecs (install as needed)

## Future Customization

All easily customizable:
- Add packages to `packages/*.txt`
- Modify KDE settings in `archiso/airootfs/etc/skel/`
- Add more MAC spoofing rules
- Configure WARP settings in `warp-setup.sh`
- Adjust Waterfox hardening in `waterfox-prefs.js`

---

**Result**: A **beautiful, functional, privacy-first OS** combining KDE Plasma's polish with **Waterfox's lightweight privacy**, **Cloudflare WARP's speed**, and **automatic MAC spoofing** for network anonymity.
