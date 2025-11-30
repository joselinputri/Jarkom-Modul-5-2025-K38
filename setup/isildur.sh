#!/bin/bash
echo "=== CLIENT SETUP ==="

# Install tools
apt-get update
apt-get install -y iputils-ping iproute2 curl netcat-openbsd

echo ""
echo "=== TESTING ==="
ping -c 2 8.8.8.8 && echo "✅ Internet OK" || echo "❌ Internet FAIL"
ping -c 2 google.com && echo "✅ DNS OK" || echo "❌ DNS FAIL"

echo ""
echo "=== CLIENT READY ==="