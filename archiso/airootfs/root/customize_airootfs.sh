#!/bin/bash
# This script is executed when the image is booted as the root user.
# Global variables (defined in /etc/profile.d/endeavour-env.sh) are available.

set -e -u

# Enable kernel hardening on boot
echo "[*] Applying kernel hardening..."
if [[ -f /etc/sysctl.d/99-hardening.conf ]]; then
    sysctl -p /etc/sysctl.d/99-hardening.conf > /dev/null 2>&1 || true
fi

echo "[*] Setting up networking..."
# Enable systemd-networkd
systemctl enable systemd-networkd.service systemd-resolved.service

echo "[*] Configuring UFW firewall..."
if command -v ufw &> /dev/null; then
    systemctl enable ufw.service || true
fi

echo "[*] Setting up privacy services..."
# Enable dnscrypt-proxy
systemctl enable dnscrypt-proxy.service || true

# Enable MAC spoofing
if command -v macchanger &> /dev/null; then
    systemctl enable macspoof@eth0.service || true
    systemctl enable macspoof@wlan0.service || true
fi

echo "[*] Initial setup complete!"
