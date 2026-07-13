#!/bin/bash
# Live environment setup script
# Launches Calamares installer and sets up KDE Plasma

# Set locale for live environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set keyboard layout
setxkbmap us

# Create autostart script for Calamares
mkdir -p /root/.config/autostart
cat > /root/.config/autostart/calamares.desktop << EOF
[Desktop Entry]
Type=Application
Exec=calamares
Name=Endeavour OS Installer
Terminal=false
Categories=System;
EOF

echo "Live environment ready. Calamares will launch on KDE Plasma startup."
