#!/bin/bash
echo "=== IRONHILLS FIREWALL SETUP (Weekend Only) ==="

# Install required tools
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y iptables iputils-ping iproute2 curl netcat-openbsd apache2 xtables-addons-common

# Restart Apache to ensure HTTP active
systemctl restart apache2

echo ""
echo "Simulasi waktu ke hari Rabu untuk pengujian (HARUS DIBLOK)..."
date -s "2025-11-27 12:00:00" >/dev/null
echo "Tanggal sekarang: $(date)"
echo "Hari: $(date +%A)"

# Flush existing rules
iptables -F
iptables -X
iptables -Z

# Default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Weekend-only access rules
iptables -A INPUT -p tcp --dport 80 -s 192.230.1.128/26 -m time --weekdays Sat,Sun -j ACCEPT   # Durin
iptables -A INPUT -p tcp --dport 80 -s 192.230.1.192/29 -m time --weekdays Sat,Sun -j ACCEPT   # Khamul
iptables -A INPUT -p tcp --dport 80 -s 192.230.0.0/24  -m time --weekdays Sat,Sun -j ACCEPT    # Elendil & Isildur

# Block all HTTP outside schedule
iptables -A INPUT -p tcp --dport 80 -j DROP

echo ""
echo "🔥 FIREWALL BERHASIL DIKONFIGURASI!"
echo "Rule aktif:"
iptables -L INPUT -v -n --line-numbers
echo ""

echo "================ TESTING ================"
echo "💢 Hari Rabu (harus GAGAL):"
echo "  curl -m 2 http://192.230.1.210"
echo ""
echo "👉 Untuk test hari Sabtu:"
echo "  date -s '2025-11-29 12:00:00'"
echo "  curl -m 2 http://192.230.1.210"
echo ""
echo "========================================="




chmod  +x /root/ironhills-firewall.sh
bash /root/ironhills-firewall.sh
