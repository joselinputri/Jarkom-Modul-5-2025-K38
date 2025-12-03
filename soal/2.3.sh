# ============================================
# 2.3 - NARYA (Hanya Vilya akses port 53)
# ============================================
cat > /root/narya-firewall.sh << 'EOF'
#!/bin/bash
echo "=== NARYA FIREWALL SETUP ==="

# Install tools
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y iptables iputils-ping iproute2 curl netcat-openbsd bind9 dnsutils

# Flush existing rules
iptables -F
iptables -X
iptables -Z

# Default policy
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (jika diperlukan)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow ONLY Vilya (192.230.1.202) to access DNS port 53
iptables -A INPUT -p tcp --dport 53 -s 192.230.1.202 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 192.230.1.202 -j ACCEPT

# Block DNS port from others
iptables -A INPUT -p tcp --dport 53 -j DROP
iptables -A INPUT -p udp --dport 53 -j DROP

echo ""
echo "✅ Firewall configured!"
echo ""
echo "Rules applied:"
iptables -L INPUT -v -n --line-numbers
echo ""
echo "Only Vilya (192.230.1.202) can access port 53"
echo ""
echo "=== TESTING INSTRUCTIONS ==="
echo "Dari Vilya (HARUS BERHASIL):"
echo "  nc -zv 192.230.1.203 53"
echo "  dig @192.230.1.203 google.com"
echo ""
echo "Dari client lain (HARUS GAGAL):"
echo "  nc -zv 192.230.1.203 53"
echo ""
echo "⚠️  INGAT: Hapus rules ini setelah testing agar DNS bisa diakses untuk install paket!"
echo "    iptables -D INPUT -p tcp --dport 53 -j DROP"
echo "    iptables -D INPUT -p udp --dport 53 -j DROP"
EOF

chmod +x /root/narya-firewall.sh
bash /root/narya-firewall.sh



Cek di khamul
nc -zvw 1 192.230.1.203 53

Kalau di client 
apt-get install -y netcat-openbsd

cek udah drop apa tidak
iptables -L INPUT -v -n --line-numbers | grep 53


