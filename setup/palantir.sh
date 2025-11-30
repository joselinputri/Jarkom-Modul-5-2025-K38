#!/bin/bash
echo "=== WEB SERVER SETUP ==="

# Install tools & Web Server
apt-get update
apt-get install -y iputils-ping iproute2 nginx

# Dapatkan hostname
HOSTNAME=$(hostname)

# Buat index.html
echo "Welcome to $HOSTNAME" > /var/www/html/index.html

# Start nginx
service nginx start

echo ""
echo "=== TESTING ==="
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"
curl http://localhost && echo "✅ Web Server OK" || echo "❌ Web Server FAIL"

echo ""
echo "=== WEB SERVER READY ==="