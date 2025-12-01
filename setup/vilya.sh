Vilya
cat > /root/setup.sh << 'EOF'
#!/bin/bash
echo "=== FIXING DNS CONFIGURATION IN DHCP SERVER ==="
# Backup
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup
# Write new config with correct DNS
cat > /etc/dhcp/dhcpd.conf << 'DHCP_EOF'
# Global DNS option
option domain-name-servers 192.230.1.203;
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
DHCP_EOF
# Test config
echo ""
echo "Testing DHCP configuration..."
dhcpd -t -cf /etc/dhcp/dhcpd.conf
if [ $? -eq 0 ]; then
echo "✅ Configuration OK"
echo ""
echo "Restarting DHCP server..."
service isc-dhcp-server restart
echo ""
echo "✅ DHCP Server restarted"
echo ""
echo "Now clients need to renew their IP:"
echo " Run on client: dhclient -r ethX && dhclient ethX"
else
echo "❌ Configuration ERROR"
echo "Restoring backup..."
mv /etc/dhcp/dhcpd.conf.backup /etc/dhcp/dhcpd.conf
fi
EOF
chmod +x /root/setup.sh
bash /root/setup.sh

