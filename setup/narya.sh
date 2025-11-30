#!/bin/bash
echo "=== NARYA (DNS SERVER) SETUP ==="

# Install tools & DNS Server
apt-get update
apt-get install -y iputils-ping iproute2 bind9

# Konfigurasi DNS Server
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders {
        192.168.122.1;
        8.8.8.8;
    };
    allow-query { any; };
    listen-on-v6 { any; };
};
EOF

# Restart DNS Server
service bind9 restart

echo ""
echo "=== TESTING ==="
ping -c 2 192.230.1.201 && echo "✅ Rivendell OK" || echo "❌ Rivendell FAIL"
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"

echo ""
echo "=== NARYA READY ==="