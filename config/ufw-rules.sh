#!/bin/bash
# UFW Firewall Rules for Privacy Edition
# Default deny all incoming, allow outgoing through WARP

echo "[*] Configuring UFW Firewall..."

# Reset to defaults
ufw --force reset

# Set default policies
ufw default deny incoming
ufw default allow outgoing
ufw default deny routed

# Allow loopback
ufw allow in on lo
ufw allow out on lo

# Allow SSH (optional, can be removed)
# ufw allow ssh

# Allow DNS (through dnscrypt-proxy)
ufw allow out 127.0.0.1 port 53000 proto udp
ufw allow out 127.0.0.1 port 53000 proto tcp

# Allow DNS (system resolver)
ufw allow out port 53 proto udp
ufw allow out port 53 proto tcp

# Allow WARP (usually port 1701 for L2TP or custom)
ufw allow out port 1701

# Allow HTTPS/HTTP (through WARP)
ufw allow out port 80 proto tcp
ufw allow out port 443 proto tcp

# Enable firewall
ufw enable

echo "[✓] UFW configured"
ufw status verbose
