apt-get update && apt-get install -y iptables

cat > setup_portscan.sh << 'EOF'
#!/bin/bash
echo "[*] Setting up Port Scan Detection on Palantir..."

# 1. Reset rules
iptables -F PORTSCAN 2>/dev/null
iptables -X PORTSCAN 2>/dev/null
iptables -F INPUT

# 2. Buat Chain PORTSCAN untuk Log dan Drop
iptables -N PORTSCAN
iptables -A PORTSCAN -m limit --limit 2/min -j LOG --log-prefix "PORT_SCAN_DETECTED: " --log-level 4
iptables -A PORTSCAN -j DROP

# 3. Whitelist trafik yang aman/sudah terhubung
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# 4. LOGIC UTAMA: Deteksi Port Scan (>15 hit dalam 20 detik)
# Cek apakah IP sudah kena limit?
iptables -A INPUT -p tcp --syn -m recent --name SCANNER_LIST --update --seconds 20 --hitcount 15 -j PORTSCAN
# Jika belum, catat IP tersebut
iptables -A INPUT -p tcp --syn -m recent --name SCANNER_LIST --set

echo "[+] Configuration applied on Palantir!"
iptables -L INPUT -n -v
EOF

chmod +x setup_portscan.sh && ./setup_portscan.sh
