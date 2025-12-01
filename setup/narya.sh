cat > /root/setup.sh << 'EOFSCRIPT'
#!/bin/bash
echo "=== NARYA (DNS SERVER) SETUP ==="
export DEBIAN_FRONTEND=noninteractive

# Install packages
apt-get update -qq
apt-get install -y iputils-ping iproute2 curl netcat-openbsd bind9-dnsutils procps bind9

# Kill existing BIND9
killall -9 named 2>/dev/null || true
sleep 2

# Buat named.conf yang benar
cat > /etc/bind/named.conf << 'NAMEDCONF'
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
NAMEDCONF

# Buat named.conf.local (kosong tapi harus ada)
touch /etc/bind/named.conf.local

# Configure BIND9 options
cat > /etc/bind/named.conf.options << 'DNSCONF'
options {
    directory "/var/cache/bind";
    
    # Forward ke upstream DNS
    forwarders {
        192.168.122.1;
        8.8.8.8;
    };
    
    forward only;
    
    # Allow query dari semua IP di jaringan
    allow-query { any; };
    
    # Listen di semua interface
    listen-on { any; };
    
    # Disable IPv6
    listen-on-v6 { none; };
    
    # Disable DNSSEC validation
    dnssec-validation no;
    
    # Enable recursion
    recursion yes;
};
DNSCONF

# Check configuration
echo "Checking BIND9 configuration..."
named-checkconf

if [ $? -ne 0 ]; then
    echo "❌ Configuration ERROR"
    exit 1
fi

echo "✅ Configuration OK"

# Create necessary directories
mkdir -p /var/cache/bind /run/named
chown -R bind:bind /var/cache/bind /run/named

# Start BIND9 (IPv4 only)
echo "Starting BIND9..."
/usr/sbin/named -u bind -4

# Wait for service to start
sleep 5

echo ""
echo "=== TESTING ==="

# Check if process is running
if ps aux | grep -v grep | grep named > /dev/null; then
    echo "✅ DNS Server Running"
    ps aux | grep named | grep -v grep
else
    echo "❌ DNS Server NOT Running"
    exit 1
fi

# Test DNS resolution
echo ""
echo "Testing DNS resolution to google.com..."
RESULT=$(dig @127.0.0.1 google.com +short 2>&1 | head -1)

if echo "$RESULT" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' > /dev/null; then
    echo "✅ DNS Resolution OK: $RESULT"
else
    echo "⚠️  DNS Resolution: $RESULT"
fi

# Test DNS dari IP sendiri (192.230.1.203)
echo ""
echo "Testing DNS from Narya IP (192.230.1.203)..."
dig @192.230.1.203 google.com +short | head -1

# Show listening ports
echo ""
echo "DNS Server listening on:"
netstat -tulpn 2>/dev/null | grep :53 || ss -tulpn | grep :53

echo ""
echo "=== NARYA DNS SERVER READY ==="
echo "IP Address: 192.230.1.203"
echo "Subnet: 192.230.1.200/29"
echo "Gateway: 192.230.1.201 (Rivendell)"
echo "Clients should use: nameserver 192.230.1.203"
EOFSCRIPT

chmod +x /root/setup.sh
bash /root/setup.sh