#!/bin/bash
echo "=== MORIA SETUP ==="

# Install tools
apt-get update
apt-get install -y iputils-ping iproute2

echo "✅ Moria ready (routing sudah dari /etc/network/interfaces)"