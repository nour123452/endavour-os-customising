#!/bin/bash
# UFW Firewall configuration script
# Run this to configure firewall on first boot

echo "[*] Configuring UFW Firewall..."

# Reset to defaults
sudo ufw --force reset || true

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# Allow loopback
sudo ufw allow in on lo
sudo ufw allow out on lo

# Allow DNS
sudo ufw allow out 127.0.0.1 port 53000 proto udp
sudo ufw allow out 127.0.0.1 port 53000 proto tcp
sudo ufw allow out port 53 proto udp
sudo ufw allow out port 53 proto tcp

# Allow WARP
sudo ufw allow out port 1701

# Allow HTTP/HTTPS
sudo ufw allow out port 80 proto tcp
sudo ufw allow out port 443 proto tcp

# Enable firewall
sudo ufw enable

echo "[✓] UFW configured"
sudo ufw status verbose
