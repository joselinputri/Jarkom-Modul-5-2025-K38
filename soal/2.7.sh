apt-get update && apt-get install -y iptables curl

cat > setup_redirect.sh << 'EOF'
#!/bin/bash
echo "[*] Setting up Traffic Redirection on Vilya..."

# 1. Flush NAT rules
iptables -t nat -F OUTPUT

# 2. Apply DNAT Rule
# Target: Traffic from Vilya to Subnet Khamul (192.230.1.192/29) -> Redirect to IronHills
iptables -t nat -A OUTPUT -d 192.230.1.192/29 -p tcp --dport 80 -j DNAT --to-destination 192.230.1.210:80

echo "[+] Configuration applied on Vilya!"
iptables -t nat -L OUTPUT -n -v
echo "[*] Test Hint: curl -I http://192.230.1.193 (Salah satu IP Khamul)"
EOF

chmod +x setup_redirect.sh && ./setup_redirect.sh
