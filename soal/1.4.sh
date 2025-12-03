#!/bin/bash
clear
echo "=== MODUL 5 - TESTING ALL SERVICES (AUTO INSTALL TOOLS) ==="
echo "$(date)"
echo ""

HOST=$(hostname)
IP=$(ip -4 addr show | grep "inet 192.230" | awk '{print $2}' | head -1)

echo "From: $HOST"
echo "IP:   $IP"
echo ""

# ============================================================
# AUTO INSTALL MISSING TOOLS
# ============================================================
echo "=== CHECKING REQUIRED TOOLS ==="

REQUIRED_TOOLS=("dig" "curl" "nc")
MISSING=()

for TOOL in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $TOOL >/dev/null 2>&1; then
        echo " - Missing: $TOOL"
        MISSING+=("$TOOL")
    else
        echo " - OK: $TOOL found"
    fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
    echo "Installing missing tools..."
    apt update -y >/dev/null 2>&1

    for TOOL in "${MISSING[@]}"; do
        case $TOOL in
            dig)  apt install -y dnsutils >/dev/null 2>&1 ;;
            curl) apt install -y curl >/dev/null 2>&1 ;;
            nc)   apt install -y netcat-traditional >/dev/null 2>&1 ;;
        esac
    done
    echo "Tools installed!"
else
    echo "All tools OK."
fi

echo ""

# ============================================================
# TEST 1: DHCP CLIENT
# ============================================================
echo "=== TEST 1: DHCP CLIENT ==="
grep nameserver /etc/resolv.conf
if grep -q "192.230.1.203" /etc/resolv.conf; then
    echo "DNS server OK"
else
    echo "DNS server WRONG"
fi
echo ""

# ============================================================
# TEST 2: DNS SERVER
# ============================================================
echo "=== TEST 2: DNS SERVER ==="

if ! command -v dig >/dev/null 2>&1; then
    echo "dig still not available"
else
    echo "> dig google.com:"
    dig google.com +short @192.230.1.203
    echo ""
fi

# ============================================================
# TEST 3: WEB SERVERS
# ============================================================
echo "=== TEST 3: WEB SERVERS ==="

for srv in "Palantir 192.230.1.234" "IronHills 192.230.1.210"; do
    NAME=$(echo $srv | awk '{print $1}')
    IP=$(echo $srv | awk '{print $2}')
    echo "[$NAME - $IP]"
    echo "curl output:"
    curl -s http://$IP
    echo ""
done

# ============================================================
# TEST 4: CONNECTIVITY
# ============================================================
echo "=== TEST 4: CONNECTIVITY ==="

for srv in \
    "Narya-DNS 192.230.1.203" \
    "Vilya-DHCP 192.230.1.202" \
    "Palantir-Web 192.230.1.234" \
    "IronHills-Web 192.230.1.210" \
    "Internet 8.8.8.8"
do
    NAME=$(echo $srv | awk '{print $1}')
    IP=$(echo $srv | awk '{print $2}')

    echo "[$NAME - $IP]"
    echo "> ping:"
    ping -c 1 $IP
    echo "> nc port test (80):"
    nc -zv -w 2 $IP 80
    echo ""
done


chmod +x /root/test-all-services.sh
bash /root/test-all-services.sh
