#!/bin/bash
echo "=== IRONHILLS WEB SERVER SETUP ==="
export DEBIAN_FRONTEND=noninteractive

# Install apache2 dan tools lengkap
apt-get update -qq
apt-get install -y apache2 curl net-tools iproute2 iputils-ping

# Stop apache2 dulu (kalau jalan)
service apache2 stop 2>/dev/null

# Buat index.html
echo "Welcome to IronHills" > /var/www/html/index.html

# Start Apache2
service apache2 start

echo ""
echo "=== TESTING ==="

# Cek proses
if ps aux | grep -v grep | grep apache2 > /dev/null; then
    echo "✅ Apache2 Running"
else
    echo "❌ Apache2 NOT Running"
fi

# Cek port (pakai netstat kalau ss ga ada)
if command -v ss &> /dev/null; then
    ss -tuln | grep :80 && echo "✅ Port 80 Listening"
elif command -v netstat &> /dev/null; then
    netstat -tuln | grep :80 && echo "✅ Port 80 Listening"
else
    echo "⚠️  Cannot check port (install net-tools)"
fi

# Test HTTP
sleep 2
if command -v curl &> /dev/null; then
    curl -s localhost | grep -q "IronHills" && echo "✅ Web Server OK" || echo "❌ Web Server FAIL"
else
    echo "⚠️  curl not installed, cannot test"
fi

echo ""
echo "=== IRONHILLS WEB SERVER READY ==="
echo "Access at: http://192.230.1.210"


# tes 
curl 192.230.1.210