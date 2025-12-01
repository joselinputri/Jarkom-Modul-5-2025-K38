# 1. Cek proses apa yang pakai port 80
netstat -tulpn | grep :80
# atau
ss -tulpn | grep :80

# 2. Kill proses yang pakai port 80
killall apache2 2>/dev/null
pkill -9 apache2 2>/dev/null
fuser -k 80/tcp 2>/dev/null

# 3. Wait
sleep 2

# 4. Cek lagi (harusnya kosong)
netstat -tulpn | grep :80

# 5. Buat script yang benar
cat > /root/setup-webserver.sh << 'EOF'
#!/bin/bash
echo "=== IRONHILLS WEB SERVER SETUP ==="
export DEBIAN_FRONTEND=noninteractive

# Install apache2
apt-get update -qq
apt-get install -y apache2

# Stop semua apache yang running
service apache2 stop 2>/dev/null
killall apache2 2>/dev/null
sleep 2

# Get hostname
HOSTNAME=$(hostname)

# Create index.html
cat > /var/www/html/index.html << HTMLEOF
<!DOCTYPE html>
<html>
<head>
    <title>$HOSTNAME</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        h1 {
            color: #333;
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to $HOSTNAME</h1>
    </div>
</body>
</html>
HTMLEOF

# Fix ServerName warning
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Start Apache dengan cara manual
echo "Starting Apache2..."
/usr/sbin/apache2ctl start

sleep 3

echo ""
echo "=== TESTING ==="

# Check if running
if ps aux | grep apache2 | grep -v grep; then
    echo "✅ Apache2 Running"
else
    echo "❌ Apache2 NOT Running"
    echo "Checking ports..."
    netstat -tulpn | grep :80 || ss -tulpn | grep :80
    exit 1
fi

# Check port 80
if netstat -tulpn 2>/dev/null | grep :80 || ss -tulpn | grep :80; then
    echo "✅ Port 80 is listening"
else
    echo "❌ Port 80 is NOT listening"
fi

# Test HTTP response
echo ""
echo "Testing HTTP response..."
curl -s http://localhost | head -5

echo ""
echo "=== IRONHILLS WEB SERVER READY ==="
echo "Access at: http://192.230.1.210"
EOF

chmod +x /root/setup-webserver.sh
bash /root/setup-webserver.sh