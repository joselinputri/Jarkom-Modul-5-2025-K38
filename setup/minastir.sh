cat > /root/setup-relay.sh << 'EOF'
#!/bin/bash
echo "=== MINASTIR DHCP RELAY SETUP ==="
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y isc-dhcp-relay procps

cat > /etc/default/isc-dhcp-relay << 'RELAYCONF'
SERVERS="192.230.1.202"
INTERFACES="eth0 eth2"
OPTIONS=""
RELAYCONF

service isc-dhcp-relay restart

sleep 2

if ps aux | grep dhcrelay | grep -v grep; then
    echo "✅ DHCP Relay Running"
    ps aux | grep dhcrelay | grep -v grep
else
    echo "❌ DHCP Relay Failed"
fi

echo ""
echo "=== MINASTIR DHCP RELAY READY ==="
EOF

chmod +x /root/setup-relay.sh
bash /root/setup-relay.sh

