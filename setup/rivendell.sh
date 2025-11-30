#!/bin/bash
echo "=== RIVENDELL SETUP ==="

# Install tools & DHCP Relay
apt-get update
apt-get install -y iputils-ping iproute2 isc-dhcp-relay

# Konfigurasi DHCP Relay
echo 'SERVERS="192.230.1.202"' > /etc/default/isc-dhcp-relay
echo 'INTERFACES="eth1 eth3"' >> /etc/default/isc-dhcp-relay
echo 'OPTIONS=""' >> /etc/default/isc-dhcp-relay

# Restart DHCP Relay
service isc-dhcp-relay restart

echo ""
echo "=== TESTING ==="
ping -c 2 192.230.1.221 && echo "✅ Osgiliath OK" || echo "❌ Osgiliath FAIL"
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"

echo ""
echo "=== RIVENDELL READY ==="