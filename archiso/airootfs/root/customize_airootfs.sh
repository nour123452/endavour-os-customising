#!/bin/bash
# archiso customize_airootfs script

set -e -u

echo "[*] Customizing archiso root filesystem..."

# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Set locale
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen

# Set hostname
echo "endeavour-privacy" > /etc/hostname

# Enable services
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable getty@tty1.service

# Kernel hardening on boot
sysctl -p /etc/sysctl.d/99-hardening.conf > /dev/null 2>&1 || true

echo "[✓] Customization complete"
