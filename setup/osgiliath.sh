#!/bin/bash
echo "=== OSGILIATH SETUP ==="

# Install tools yang dibutuhkan
apt-get update
apt-get install -y iptables iputils-ping iproute2 curl wget netcat-openbsd

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Tunggu eth0 dapat IP dari DHCP
sleep 3

# Dapatkan IP eth0
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "ETH0 IP: $ETH0_IP"

# Flush iptables
iptables -t nat -F
iptables -F
iptables -X

# Setup NAT dengan SNAT (BUKAN MASQUERADE - sesuai soal)
iptables -t nat -A POSTROUTING -s 192.230.0.0/22 -o eth0 -j SNAT --to-source $ETH0_IP

# Setup FORWARD rules
iptables -P FORWARD ACCEPT
iptables -A FORWARD -s 192.230.0.0/22 -j ACCEPT
iptables -A FORWARD -d 192.230.0.0/22 -m state --state RELATED,ESTABLISHED -j ACCEPT

echo ""
echo "=== NAT CONFIGURED ==="
iptables -t nat -L -v -n

echo ""
echo "=== TESTING ==="
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"
ping -c 2 google.com && echo "✅ DNS OK" || echo "❌ DNS FAIL"

echo ""
echo "=== OSGILIATH READY ==="