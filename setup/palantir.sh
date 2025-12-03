#!/bin/bash
echo "=== PALANTIR WEB SERVER SETUP ==="

# Install nginx dan tools
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nginx iputils-ping iproute2 curl

# Buat index.html
echo "Welcome to Palantir" > /var/www/html/index.html

# Start nginx
service nginx start

echo "=== TESTING ==="
# Test internet
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"

# Test web server
curl -s localhost | grep -q "Palantir" && echo "✅ Web Server OK" || echo "❌ Web Server FAIL"

echo "=== WEB SERVER READY ==="


# tes 
curl 192.230.1.234 