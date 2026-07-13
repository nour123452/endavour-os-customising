#!/bin/bash
# Post-installation setup for Endeavour OS Privacy Edition

echo "[*] Running post-installation setup..."

# Enable UFW firewall
echo "[*] Enabling firewall..."
sudo systemctl enable ufw
sudo systemctl start ufw

# Configure dnscrypt-proxy
echo "[*] Configuring DNS privacy..."
sudo systemctl enable dnscrypt-proxy
sudo systemctl start dnscrypt-proxy

# Enable MAC spoofing
echo "[*] Enabling automatic MAC spoofing..."
sudo systemctl enable macspoof@eth0 2>/dev/null || true
sudo systemctl enable macspoof@wlan0 2>/dev/null || true

# Make refresh-ip executable
echo "[*] Installing refresh-ip utility..."
sudo cp /usr/local/bin/refresh-ip.sh /usr/local/bin/refresh-ip
sudo chmod +x /usr/local/bin/refresh-ip

# Configure Cloudflare WARP
echo "[*] Setting up Cloudflare WARP..."
sudo systemctl enable warp-svc
sudo systemctl start warp-svc

echo "[✓] Post-installation setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run: sudo refresh-ip (to test IP refresh)"
echo "  2. Run: warp-cli registration new (to register with WARP)"
echo "  3. Run: warp-cli connect (to connect to WARP)"
echo "  4. Check firewall: sudo ufw status verbose"
