#!/bin/bash
echo "=== VILYA (DHCP SERVER) SETUP ==="

# Install tools & DHCP Server
apt-get update
apt-get install -y iputils-ping iproute2 isc-dhcp-server

# Konfigurasi DHCP Server
cat > /etc/dhcp/dhcpd.conf << 'EOF'
# A3 - Durin (50 host)
subnet 192.230.1.128 netmask 255.255.255.192 {
    range 192.230.1.130 192.230.1.190;
    option routers 192.230.1.129;
    option broadcast-address 192.230.1.191;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# A4 - Khamul (5 host)
subnet 192.230.1.192 netmask 255.255.255.248 {
    range 192.230.1.194 192.230.1.198;
    option routers 192.230.1.193;
    option broadcast-address 192.230.1.199;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# A9 - Elendil & Isildur (230 host)
subnet 192.230.0.0 netmask 255.255.255.0 {
    range 192.230.0.2 192.230.0.254;
    option routers 192.230.0.1;
    option broadcast-address 192.230.0.255;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# A13 - Gilgalad & Cirdan (120 host)
subnet 192.230.1.0 netmask 255.255.255.128 {
    range 192.230.1.2 192.230.1.126;
    option routers 192.230.1.1;
    option broadcast-address 192.230.1.127;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# Subnet untuk interface Vilya sendiri
subnet 192.230.1.200 netmask 255.255.255.248 {
}
EOF

# Set interface DHCP Server
echo 'INTERFACESv4="eth1"' > /etc/default/isc-dhcp-server

# Restart DHCP Server
service isc-dhcp-server restart

echo ""
echo "=== TESTING ==="
ping -c 2 192.230.1.201 && echo "✅ Rivendell OK" || echo "❌ Rivendell FAIL"
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"

echo ""
echo "=== VILYA READY ==="