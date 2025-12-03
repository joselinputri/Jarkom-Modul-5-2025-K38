cat > /root/vilya_dhcp_complete.sh << 'EOF'
#!/bin/bash

echo "=========================================="
echo "   VILYA DHCP SERVER - COMPLETE SETUP"
echo "=========================================="

# ============================================
# STEP 1: Install DHCP Server
# ============================================
echo ""
echo "Step 1: Installing isc-dhcp-server..."
apt update
apt install -y isc-dhcp-server

# ============================================
# STEP 2: Configure Network Interface
# ============================================
echo ""
echo "Step 2: Configuring network interface..."
cat > /etc/network/interfaces << 'NET_EOF'
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.230.1.202
    netmask 255.255.255.248
    gateway 192.230.1.201
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
NET_EOF

echo "Network configuration created."

# ============================================
# STEP 3: Create DHCP Configuration
# ============================================
echo ""
echo "Step 3: Creating DHCP configuration..."
cat > /etc/dhcp/dhcpd.conf << 'DHCP_EOF'
# Global DNS option
option domain-name-servers 192.230.1.203;

# Subnet where DHCP server itself is located (MUST be declared)
subnet 192.230.1.200 netmask 255.255.255.248 {
    # No DHCP range here, just declaration
}

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

# A1 - Elendil & Isildur (200+30 host)
subnet 192.230.0.0 netmask 255.255.255.0 {
    range 192.230.0.10 192.230.0.250;
    option routers 192.230.0.1;
    option broadcast-address 192.230.0.255;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# A2 - Gilgalad & Cirdan (100+20 host)
subnet 192.230.1.0 netmask 255.255.255.128 {
    range 192.230.1.10 192.230.1.120;
    option routers 192.230.1.1;
    option broadcast-address 192.230.1.127;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}
DHCP_EOF

echo "DHCP configuration created."

# ============================================
# STEP 4: Configure DHCP Interface
# ============================================
echo ""
echo "Step 4: Setting DHCP interface..."
cat > /etc/default/isc-dhcp-server << 'IFACE_EOF'
DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
DHCPDv4_PID=/var/run/dhcpd.pid
INTERFACESv4="eth1"
IFACE_EOF

echo "DHCP interface set to eth1."

# ============================================
# STEP 5: Test Configuration
# ============================================
echo ""
echo "Step 5: Testing DHCP configuration..."
dhcpd -t -cf /etc/dhcp/dhcpd.conf

if [ $? -ne 0 ]; then
    echo "❌ Configuration test FAILED!"
    exit 1
fi

echo "✅ Configuration test PASSED!"

# ============================================
# STEP 6: Clean and Start Service
# ============================================
echo ""
echo "Step 6: Cleaning old processes and starting service..."

# Kill any existing dhcpd
killall dhcpd 2>/dev/null
sleep 2

# Clean PID files
rm -f /var/run/dhcpd.pid
rm -f /run/dhcpd.pid

# Force kill if still running
if pidof dhcpd > /dev/null; then
    kill -9 $(pidof dhcpd) 2>/dev/null
    sleep 1
fi

# Start the service
service isc-dhcp-server start
sleep 3

# ============================================
# STEP 7: Verify Service is Running
# ============================================
echo ""
echo "Step 7: Verifying service status..."

if pidof dhcpd > /dev/null; then
    PID=$(pidof dhcpd)
    echo "✅ DHCP Server is RUNNING!"
    echo "   PID: $PID"
else
    echo "❌ DHCP Server FAILED to start!"
    echo ""
    echo "Attempting manual start for debugging..."
    dhcpd -4 -f -d -cf /etc/dhcp/dhcpd.conf eth1 &
    sleep 2
    
    if pidof dhcpd > /dev/null; then
        echo "✅ Manual start successful!"
    else
        echo "❌ Manual start failed. Check configuration."
        exit 1
    fi
fi

# ============================================
# STEP 8: Display Summary
# ============================================
echo ""
echo "=========================================="
echo "          SETUP COMPLETE!"
echo "=========================================="
echo ""
echo "DHCP Server Status: RUNNING ✅"
echo "Server IP: 192.230.1.202"
echo "Interface: eth1"
echo "DNS Server: 192.230.1.203"
echo ""
echo "Configured Subnets:"
echo "  📍 A1 (Elendil & Isildur): 192.230.0.0/24"
echo "     Range: 192.230.0.10 - 192.230.0.250"
echo ""
echo "  📍 A2 (Gilgalad & Cirdan): 192.230.1.0/25"
echo "     Range: 192.230.1.10 - 192.230.1.120"
echo ""
echo "  📍 A3 (Durin): 192.230.1.128/26"
echo "     Range: 192.230.1.130 - 192.230.1.190"
echo ""
echo "  📍 A4 (Khamul): 192.230.1.192/29"
echo "     Range: 192.230.1.194 - 192.230.1.198"
echo ""
echo "=========================================="
echo ""
echo "📝 DHCP Leases:"
if [ -f /var/lib/dhcp/dhcpd.leases ]; then
    cat /var/lib/dhcp/dhcpd.leases | grep "lease " | head -5
else
    echo "   No leases yet (waiting for clients)"
fi
echo ""
echo "=========================================="
echo "Next Steps:"
echo "1. ✅ DHCP Server is ready"
echo "2. Configure DHCP Relay on:"
echo "   - AnduinBanks"
echo "   - Rivendell"
echo "   - Minastir"
echo "3. Test DHCP clients to get IP automatically"
echo "=========================================="

EOF

# Make executable and run
chmod +x /root/vilya_dhcp_complete.sh
bash /root/vilya_dhcp_complete.sh

