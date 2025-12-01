# ====================================================================
# 1. VERIFIKASI DHCP SERVER
# ====================================================================

# A. Cek DHCP Server Running (Vilya)
ps aux | grep dhcpd | grep -v grep

# B. Cek Konfigurasi DHCP (Vilya)
cat /etc/dhcp/dhcpd.conf

# C. Lihat DHCP Leases (Vilya)
cat /var/lib/dhcp/dhcpd.leases


# ====================================================================
# 2. VERIFIKASI DHCP RELAY
# ====================================================================

# A. Cek DHCP Relay di Rivendell
ps aux | grep dhcrelay | grep -v grep

# B. Cek DHCP Relay di AnduinBanks
ps aux | grep dhcrelay | grep -v grep

# C. Cek DHCP Relay di Minastir
ps aux | grep dhcrelay | grep -v grep


# ====================================================================
# 3. VERIFIKASI DNS SERVER
# ====================================================================

# A. Cek DNS Server Running (Narya)
ps aux | grep named | grep -v grep

# B. Test DNS Resolution dari Client
dig @192.230.1.203 google.com

# C. Test DNS dengan Multiple Domain
dig @192.230.1.203 detik.com +short
dig @192.230.1.203 wikipedia.org +short
nslookup google.com 192.230.1.203


# ====================================================================
# 4. VERIFIKASI WEB SERVER
# ====================================================================

# A. Cek Web Server di Palantir
ps aux | grep apache2 | grep -v grep
netstat -tulpn | grep :80

# B. Cek Web Server di IronHills
ps aux | grep apache2 | grep -v grep
netstat -tulpn | grep :80

# ====================================================================
# 5. Test Client Lain
# ====================================================================
Test

cat > /root/test-all-services.sh << 'EOF'
#!/bin/bash
clear
echo "=========================================="
echo "  MODUL 5 - TESTING ALL SERVICES"
echo "  $(date)"
echo "=========================================="
echo ""

HOSTNAME=$(hostname)
MY_IP=$(ip addr show | grep "inet 192.230" | head -1 | awk '{print $2}')

echo "🖥️  Testing from: $HOSTNAME"
echo "📍 My IP: $MY_IP"
echo ""

# TEST 1: DHCP CLIENT
echo "=========================================="
echo "[TEST 1] DHCP CLIENT CONFIGURATION"
echo "=========================================="
echo ""
echo "Network Configuration:"
ip addr show | grep -A 2 "inet 192.230" | head -6
echo ""
echo "DNS Configuration:"
cat /etc/resolv.conf | grep nameserver
echo ""

if cat /etc/resolv.conf | grep -q "192.230.1.203"; then
    echo "✅ PASS: DNS Server set to Narya (192.230.1.203)"
else
    echo "❌ FAIL: DNS Server not configured correctly"
fi
echo ""

# TEST 2: DNS SERVER
echo "=========================================="
echo "[TEST 2] DNS SERVER (NARYA)"
echo "=========================================="
echo ""

DNS_TEST1=$(dig @192.230.1.203 google.com +short 2>&1 | head -1)
DNS_TEST2=$(dig @192.230.1.203 detik.com +short 2>&1 | head -1)

echo "Test 1 - Resolving google.com:"
if echo "$DNS_TEST1" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "  ✅ PASS: $DNS_TEST1"
else
    echo "  ❌ FAIL: $DNS_TEST1"
fi

echo ""
echo "Test 2 - Resolving detik.com:"
if echo "$DNS_TEST2" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "  ✅ PASS: $DNS_TEST2"
else
    echo "  ❌ FAIL: $DNS_TEST2"
fi
echo ""

# TEST 3: WEB SERVER PALANTIR
echo "=========================================="
echo "[TEST 3] WEB SERVER - PALANTIR"
echo "=========================================="
echo ""

PALANTIR=$(curl -s --max-time 5 http://192.230.1.234 2>&1)
if echo "$PALANTIR" | grep -q "Welcome to"; then
    WELCOME=$(echo "$PALANTIR" | grep -o "Welcome to [^<]*" | head -1)
    echo "  ✅ PASS: $WELCOME"
else
    echo "  ❌ FAIL: Web server not responding"
fi
echo ""

# TEST 4: WEB SERVER IRONHILLS
echo "=========================================="
echo "[TEST 4] WEB SERVER - IRONHILLS"
echo "=========================================="
echo ""

IRONHILLS=$(curl -s --max-time 5 http://192.230.1.210 2>&1)
if echo "$IRONHILLS" | grep -q "Welcome to"; then
    WELCOME=$(echo "$IRONHILLS" | grep -o "Welcome to [^<]*" | head -1)
    echo "  ✅ PASS: $WELCOME"
else
    echo "  ❌ FAIL: Web server not responding"
fi
echo ""

# TEST 5: NETWORK CONNECTIVITY
echo "=========================================="
echo "[TEST 5] NETWORK CONNECTIVITY"
echo "=========================================="
echo ""

test_ping() {
    local NAME=$1
    local IP=$2
    echo -n "  $NAME ($IP): "
    if ping -c 2 -W 2 $IP >/dev/null 2>&1; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
    fi
}

test_ping "Narya (DNS)" "192.230.1.203"
test_ping "Vilya (DHCP)" "192.230.1.202"
test_ping "Palantir (Web)" "192.230.1.234"
test_ping "IronHills (Web)" "192.230.1.210"
test_ping "Internet" "8.8.8.8"
echo ""

# SUMMARY
echo "=========================================="
echo "  TESTING COMPLETED"
echo "=========================================="
echo ""
echo "📝 Summary:"
echo "  - DHCP Client: $(cat /etc/resolv.conf | grep -q '192.230.1.203' && echo 'CONFIGURED' || echo 'NOT CONFIGURED')"
echo "  - DNS Server: $(dig @192.230.1.203 google.com +short >/dev/null 2>&1 && echo 'WORKING' || echo 'NOT WORKING')"
echo "  - Web Palantir: $(curl -s --max-time 3 http://192.230.1.234 >/dev/null 2>&1 && echo 'WORKING' || echo 'NOT WORKING')"
echo "  - Web IronHills: $(curl -s --max-time 3 http://192.230.1.210 >/dev/null 2>&1 && echo 'WORKING' || echo 'NOT WORKING')"
echo ""
echo "=========================================="
EOF

chmod +x /root/test-all-services.sh
bash /root/test-all-services.sh

