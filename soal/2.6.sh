apt-get update && apt-get install -y iptables

cat > setup_connlimit.sh << 'EOF'
#!/bin/bash
echo "[*] Setting up Connection Limiting on IronHills..."

# Simulasi Hari Sabtu (Sesuai Soal)
date -s "2023-12-02 12:00:00"

# 1. Flush Rules
iptables -F INPUT

# 2. Allow Established/Related (Optimasi Performa)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 3. Apply Connection Limit Rule (Sabtu/Minggu, Max 3 koneksi)
iptables -A INPUT -p tcp --syn --dport 80 -m time --weekdays Sat,Sun -m connlimit --connlimit-above 3 -j REJECT

# 4. Allow Normal Traffic
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "[+] Configuration applied on IronHills!"
iptables -L INPUT -n -v | grep connlimit
EOF

chmod +x setup_connlimit.sh && ./setup_connlimit.sh
