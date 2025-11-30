#!/bin/bash
echo "=== PELARGIR SETUP ==="

# Install tools
apt-get update
apt-get install -y iputils-ping iproute2

echo "✅ Pelargir ready (routing sudah dari /etc/network/interfaces)"