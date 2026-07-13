#!/bin/bash
# IP Refresh Script - Attempt to get new public IP
# Combines MAC spoofing + interface restart + DHCP renewal
# Usage: refresh-ip [interface] or refresh-ip (auto-detect)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root (use: sudo refresh-ip)"
    exit 1
fi

# Detect or use provided interface
if [[ -z "$1" ]]; then
    # Auto-detect active interface
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    if [[ -z "$INTERFACE" ]]; then
        print_error "No active network interface found. Usage: sudo refresh-ip [interface]"
        exit 1
    fi
    print_status "Auto-detected interface: $INTERFACE"
else
    INTERFACE="$1"
fi

# Verify interface exists
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    print_error "Interface $INTERFACE does not exist"
    exit 1
fi

# Get current IP before refresh
print_status "Getting current public IP..."
CURRENT_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo "unknown")
print_status "Current public IP: $CURRENT_IP"

# Step 1: Bring interface down
print_status "Step 1/5: Bringing interface down..."
ip link set "$INTERFACE" down
sleep 2
print_success "Interface $INTERFACE is down"

# Step 2: Change MAC address
print_status "Step 2/5: Changing MAC address..."
OLD_MAC=$(ip link show "$INTERFACE" | grep -oP '(?<=link/ether\s)\S+')
print_status "Old MAC: $OLD_MAC"

macchanger -r "$INTERFACE" > /dev/null 2>&1
NEW_MAC=$(ip link show "$INTERFACE" | grep -oP '(?<=link/ether\s)\S+')
print_success "MAC changed to: $NEW_MAC"

# Step 3: Bring interface back up
print_status "Step 3/5: Bringing interface back up..."
ip link set "$INTERFACE" up
sleep 2
print_success "Interface $INTERFACE is up"

# Step 4: Request new DHCP lease
print_status "Step 4/5: Requesting new DHCP lease..."

# Try dhclient first (ISC DHCP client)
if command -v dhclient &> /dev/null; then
    dhclient -r "$INTERFACE" 2>/dev/null || true
    sleep 1
    dhclient "$INTERFACE" 2>/dev/null || true
# Fallback to dhcpcd
elif command -v dhcpcd &> /dev/null; then
    dhcpcd -k "$INTERFACE" 2>/dev/null || true
    sleep 1
    dhcpcd "$INTERFACE" 2>/dev/null || true
# Fallback to NetworkManager
elif command -v nmcli &> /dev/null; then
    nmcli device disconnect "$INTERFACE" 2>/dev/null || true
    sleep 1
    nmcli device connect "$INTERFACE" 2>/dev/null || true
else
    print_warning "No DHCP client found (dhclient, dhcpcd, or NetworkManager)"
fi

sleep 3
print_success "DHCP lease requested"

# Step 5: Get new IP
print_status "Step 5/5: Checking new IP address..."
sleep 2

NEW_IP=$(curl -s https://api.ipify.org 2>/dev/null || echo "unknown")

if [[ "$NEW_IP" == "unknown" ]]; then
    print_warning "Could not determine public IP (no internet connection?)"
else
    print_success "New public IP: $NEW_IP"
    
    if [[ "$CURRENT_IP" != "$NEW_IP" ]]; then
        print_success "IP successfully changed!"
        print_success "Old IP: $CURRENT_IP"
        print_success "New IP: $NEW_IP"
    else
        print_warning "IP address is still the same ($NEW_IP)"
        print_warning "This could mean:"
        print_warning "  1. Your ISP uses 'sticky' IPs (won't change on restart)"
        print_warning "  2. Your IP is static (permanent assignment)"
        print_warning "  3. ISP hasn't assigned a new lease yet (try again later)"
    fi
fi

# Display interface info
print_status "Interface Information:"
echo "  Interface: $INTERFACE"
echo "  IP Address: $(ip addr show "$INTERFACE" | grep 'inet ' | awk '{print $2}')"
echo "  MAC Address: $(ip link show "$INTERFACE" | grep -oP '(?<=link/ether\s)\S+')"

print_success "IP refresh process complete!"
