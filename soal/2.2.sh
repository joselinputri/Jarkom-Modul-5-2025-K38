cat > /root/vilya-firewall.sh << 'EOF'
#!/bin/bash
echo "=== VILYA FIREWALL SETUP ==="

# Install tools
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y iptables iputils-ping iproute2 curl netcat-openbsd

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

# Blokir ICMP echo-request dari luar (orang lain ping ke Vilya)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Vilya masih bisa ping keluar (OUTPUT tidak diblokir)
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

echo ""
echo "✅ Firewall configured!"
echo ""
echo "Rules applied:"
iptables -L INPUT -v -n --line-numbers
echo ""
echo "Testing dari Vilya ke luar:"
ping -c 2 8.8.8.8 && echo "✅ Vilya can ping out" || echo "❌ Ping failed"
ping -c 2 192.230.1.203 && echo "✅ Can ping Narya" || echo "❌ Cannot ping Narya"
echo ""
echo "Test dari CLIENT lain (harus GAGAL):"
echo "ping 192.230.1.202"
EOF
chmod +x /root/vilya-firewall.sh
bash  /root/vilya-firewall.sh

