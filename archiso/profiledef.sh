#!/usr/bin/env bash
# Arch Linux archiso profile configuration
# Endeavour OS Privacy Edition with KDE Plasma

iso_name="endeavour-privacy-kde"
iso_label="ENDEAVOUR_KDE"
iso_application="Endeavour OS Privacy Edition with KDE Plasma"
iso_version="2024.1"
install_dir="arch"
bootmodes=('bios.syslinux' 'uefi-x64.systemd-boot' 'uefi-ia32.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
sourcedate_epoch=$(date +%s)

# Maximum compression
compression="xz"
compression_options="-9 -Xbcj x86 -Xdict-size=1MiB"

# buildmodes: netinstall, iso, all
buildmodes=('iso')

# Grub configuration
grub_preset_cfg="grub_preset.cfg"
