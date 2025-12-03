apt-get update && apt-get install -y iptables

cat > setup_isolation.sh << 'EOF'
#!/bin/bash
echo "[*] Setting up Isolation on Wilderland..."

# 1. Enable Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# 2. Allow DHCP (Agar client tetap dapet IP, isolasi di level trafik data)
iptables -I FORWARD -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# 3. Block Khamul Subnet (192.230.1.192/29)
iptables -I FORWARD 2 -s 192.230.1.192/29 -j DROP
iptables -I FORWARD 3 -d 192.230.1.192/29 -j DROP

echo "[+] Configuration applied on Wilderland!"
iptables -L FORWARD -n -v
EOF

chmod +x setup_isolation.sh && ./setup_isolation.sh
