# Privacy Features Explained

Detailed breakdown of all privacy and security features in Endeavour OS Privacy Edition.

## Network Privacy

### 1. Cloudflare WARP

**What it does:**
- Routes all traffic through Cloudflare's privacy VPN
- Encrypts DNS queries (DoH - DNS over HTTPS)
- Hides your IP from websites (shown as Cloudflare IP)
- Faster than Tor, easier to use

**How to use:**
```bash
# First time setup
warp-cli registration new

# Connect to WARP
warp-cli connect

# Check status
warp-cli status

# Disconnect
warp-cli disconnect
```

**Privacy level:** Medium-High (not anonymous, but private)

### 2. MAC Address Spoofing (Auto)

**What it does:**
- Randomizes your MAC address on every network connection
- Prevents WiFi tracking across networks
- Automatic, no user action needed

**Example:**
```
Connect to WiFi A → MAC: 00:11:22:AA:BB:CC
Connect to WiFi B → MAC: AA:BB:CC:DD:EE:FF
Connect to WiFi A → MAC: 12:34:56:78:9A:BC (different!)
```

**Why it matters:**
- MAC addresses are broadcast and can identify devices
- Without spoofing: "That device is always at Starbucks"
- With spoofing: Each connection appears as different device

### 3. DNS Privacy (dnscrypt-proxy)

**What it does:**
- Encrypts DNS queries
- Uses Cloudflare DoH (DNS over HTTPS)
- Prevents ISP/network from seeing sites you visit

**Configuration:**
```bash
# Check status
sudo systemctl status dnscrypt-proxy

# View logs
sudo journalctl -u dnscrypt-proxy
```

## Firewall Privacy

### UFW (Uncomplicated Firewall)

**Default rules:**
- **Incoming:** DENY ALL (unless explicitly allowed)
- **Outgoing:** ALLOW ALL (through WARP)
- **Routed:** DENY ALL

**What this prevents:**
- Unauthorized network access
- Incoming attacks
- Exposure to network scanning

**Check rules:**
```bash
sudo ufw status verbose
```

## System Privacy

### 1. Kernel Hardening

**Enabled by default:**

| Setting | Effect |
|---------|--------|
| `ASLR` | Randomizes memory layout (prevents exploits) |
| `DEP/NX` | Marks memory as non-executable (prevents code injection) |
| `kptr_restrict` | Hides kernel pointers (prevents KASLR defeat) |
| `ptrace_scope=3` | Disables process tracing (prevents debugging attacks) |
| `unprivileged_namespaces=0` | Disables user namespaces (reduces attack surface) |
| `BPF disabled` | Disables eBPF (reduces privilege escalation) |

**Check settings:**
```bash
grep 'kernel\.' /etc/sysctl.d/99-hardening.conf
```

### 2. Waterfox Browser

**Privacy features:**
- No telemetry (enabled at source)
- No Mozilla accounts forced
- Fingerprint protection enabled
- First-party isolation
- Tracking protection
- HTTPS-Only mode

**Pre-installed extensions:**
- uBlock Origin
- Privacy Badger
- HTTPS Everywhere

**User preferences:**
Located at `~/.waterfox/profiles.ini` and `config/waterfox-user.js`

## Data Privacy

### 1. No Telemetry

**Disabled services:**
- Arch Linux telemetry
- KDE usage tracking
- Waterfox telemetry
- System crash reports
- Package update metrics

**Verification:**
```bash
# Check for telemetry processes
ps aux | grep -i telemetry

# Should return nothing
```

### 2. Stateless by Default

**What this means:**
- Nothing saved between reboots (unless persistence enabled)
- All temp files cleared on shutdown
- Cookies deleted
- Browsing history erased
- Similar to Tails OS

**Enable persistence (optional):**
```bash
# Create persistent partition on USB
sudo parted /dev/sdX mkpart primary 3GB 8GB
sudo mkfs.ext4 /dev/sdXN  # where N is partition number
```

## IP Privacy

### 1. IP Refresh Utility

**What it does:**
- Rotates your MAC address
- Requests new DHCP lease
- Gets new public IP (if ISP allows)

**Usage:**
```bash
# Auto-detect interface
sudo refresh-ip

# Or specify interface
sudo refresh-ip wlan0
```

**Limitations:**
- Some ISPs use "sticky" IPs (won't change)
- May need to reconnect WiFi manually
- Works best with dynamic IP assignments

### 2. WARP IP Rotation

**Built-in:**
- WARP provides new IP with each connection
- Different from ISP IP
- Rotates periodically

## Application Privacy

### 1. Jami (Encrypted Messaging)
- End-to-end encryption
- No central servers
- Open source

### 2. Thunderbird (Encrypted Email)
- OpenPGP integration
- Mail encryption
- Account management

### 3. KeePass (Password Manager)
- Local-only password storage
- AES-256 encryption
- Master password protected

## Privacy Comparison

| Layer | Method | Effectiveness |
|-------|--------|----------------|
| **Network** | WARP VPN | High |
| **DNS** | dnscrypt-proxy | High |
| **MAC** | Auto-spoofing | High (per network) |
| **Firewall** | UFW default-deny | High |
| **Browser** | Waterfox + extensions | Medium-High |
| **System** | Kernel hardening | High |
| **Data** | Stateless mode | Very High |
| **IP** | Refresh-ip utility | Medium (ISP dependent) |

## Best Practices

1. **Always use WARP** - Enable auto-connect
2. **Regular IP refresh** - Run `sudo refresh-ip` periodically
3. **Update regularly** - Stay on latest packages
4. **Use strong passwords** - KeePass for management
5. **Verify downloads** - Check SHA256 hashes
6. **Enable persistence carefully** - Defeats stateless advantage
7. **Don't trust the network** - Assume it's hostile
8. **Use encrypted apps** - Jami, Thunderbird+OpenPGP

## Limitations

### What This IS NOT
- **Not Tor** - Less anonymous than Tor Browser
- **Not VPN** - No traditional VPN (using WARP instead)
- **Not firewalled** - Still vulnerable to application exploits
- **Not bulletproof** - Can be defeated with effort

### What This IS
- **Fast** - Designed for everyday use
- **Private** - Protects most data
- **Simple** - Works automatically
- **Practical** - Balance of privacy and usability

## Testing Your Privacy

### Check Public IP
```bash
curl https://api.ipify.org
# Should show Cloudflare IP when using WARP
```

### Check DNS Leaks
Visit: https://dnsleaktest.com
- Should show Cloudflare DNS servers

### Check WebRTC Leaks
Visit: https://browserleaks.com/webrtc
- Should show Cloudflare IP only

### Check Fingerprint
Visit: https://coveryourtracks.eff.org
- Should show strong fingerprint protection

## Further Reading

- [Cloudflare WARP Documentation](https://developers.cloudflare.com/warp-client/)
- [dnscrypt-proxy Documentation](https://github.com/DNSCrypt/dnscrypt-proxy)
- [Kernel Hardening Guide](https://wiki.archlinux.org/title/Security)
- [Waterfox Privacy](https://www.waterfox.net/)
- [UFW Documentation](https://wiki.ubuntu.com/UncomplicatedFirewall)

---

**Remember:** Privacy is a process, not a product. No system is 100% secure.
