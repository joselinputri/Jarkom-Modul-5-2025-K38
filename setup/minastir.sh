#!/bin/bash
echo "=== MINASTIR (DHCP RELAY) SETUP ==="

# Install tools & DHCP Relay
apt-get update
apt-get install -y iputils-ping iproute2 isc-dhcp-relay

# Konfigurasi DHCP Relay
echo 'SERVERS="192.230.1.202"' > /etc/default/isc-dhcp-relay
echo 'INTERFACES="eth0 eth1 eth2"' >> /etc/default/isc-dhcp-relay
echo 'OPTIONS=""' >> /etc/default/isc-dhcp-relay

# Restart DHCP Relay
service isc-dhcp-relay restart

echo "=== MINASTIR READY ==="