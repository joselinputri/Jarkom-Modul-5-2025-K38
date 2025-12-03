#  Laporan Praktikum Jaringan Komputer
## Modul 5 - Subnetting & Firewall Configuration

**Kelompok K38**

---

## 👥 Anggota Kelompok

| Nama | NRP |
|------|-----|
| Ahmad Syauqi Reza | 5027241085 |
| Putri Joselina Silitonga | 5027241116 |

---

## 📋 Daftar Isi

- [Topologi Jaringan](#-topologi-jaringan)
- [Pembagian Subnet VLSM](#-pembagian-subnet-vlsm)
- [Misi 1: Memetakan Medan Perang](#-misi-1-memetakan-medan-perang)
- [Misi 2: Menemukan Jejak Kegelapan](#-misi-2-menemukan-jejak-kegelapan)

---

## 🗺️ Topologi Jaringan
![topologi](top5.png)

### Keterangan Perangkat

#### 🖥️ Servers

| Server | Fungsi | IP Address |
|--------|--------|------------|
| **Narya** | DNS Server | 192.230.1.203/29 |
| **Vilya** | DHCP Server | 192.230.1.202/29 |
| **Palantir** | Web Server (Nginx) | 192.230.1.234/30 |
| **IronHills** | Web Server (Apache) | 192.230.1.210/30 |

#### 🔀 Routers

- **Osgiliath**: Main Router (Gateway to Internet)
- **Moria**: Internal Router
- **Rivendell**: DHCP Relay Router
- **Minastir**: DHCP Relay Router
- **Pelargir**: Internal Router
- **AnduinBanks**: DHCP Relay Router
- **Wilderland**: DHCP Relay Router

#### 💻 Clients

| Node | Jumlah Host | Alias | Subnet |
|------|-------------|-------|--------|
| Khamul | 5 | Burnice | A4 |
| Cirdan | 20 | Lycaon | A13 |
| Isildur | 30 | Policeboo | A9 |
| Durin | 50 | Caesar | A3 |
| Gilgalad | 100 | Ellen | A13 |
| Elendil | 200 | Jane | A9 |

---

## 📊 Pembagian Subnet VLSM

### Tabel Subnet

| Subnet | Rute | Jumlah IP | Netmask |
|--------|------|-----------|---------|
| A1 | Osgiliath > Moria > IronHills | 2 | /30 |
| A2 | Osgiliath > Moria > Wilderland | 2 | /30 |
| A3 | Osgiliath > Moria > Wilderland > Durin | 51 | /26 |
| A4 | Osgiliath > Moria > Wilderland > Khamul | 5 | /29 |
| A5 | Osgiliath > Moria | 2 | /30 |
| A6 | Osgiliath > Rivendell | 2 | /30 |
| A7 | Osgiliath > Rivendell > Switch3 > Vilya, Narya | 3 | /29 |
| A8 | Osgiliath > Minastir | 2 | /30 |
| A9 | Osgiliath > Minastir > Switch4 > Elendil, Isildur | 230 | /24 |
| A10 | Osgiliath > Minastir > Pelargir | 2 | /30 |
| A11 | Osgiliath > Minastir > Pelargir > Palantir | 2 | /30 |
| A12 | Osgiliath > Minastir > Pelargir > AnduinBanks | 2 | /30 |
| A13 | Osgiliath > Minastir > Pelargir > AnduinBanks > Switch5 > Gilgalad, Cirdan | 120 | /25 |

**Total IP: 425**

---

### Pembagian IP Detail

| Subnet | Network ID | Netmask | Broadcast | Range IP (Usable) | Prefix |
|--------|------------|---------|-----------|-------------------|--------|
| A9 | 192.230.0.0 | /24 | 192.230.0.255 | 192.230.0.1 - 192.230.0.254 | 230 |
| A13 | 192.230.1.0 | /25 | 192.230.1.127 | 192.230.1.1 - 192.230.1.126 | 120 |
| A3 | 192.230.1.128 | /26 | 192.230.1.191 | 192.230.1.129 - 192.230.1.190 | 51 |
| A4 | 192.230.1.192 | /29 | 192.230.1.199 | 192.230.1.193 - 192.230.1.198 | 5 |
| A7 | 192.230.1.200 | /29 | 192.230.1.207 | 192.230.1.201 - 192.230.1.206 | 3 |
| A1 | 192.230.1.208 | /30 | 192.230.1.211 | 192.230.1.209 - 192.230.1.210 | 2 |
| A2 | 192.230.1.212 | /30 | 192.230.1.215 | 192.230.1.213 - 192.230.1.214 | 2 |
| A5 | 192.230.1.216 | /30 | 192.230.1.219 | 192.230.1.217 - 192.230.1.218 | 2 |
| A6 | 192.230.1.220 | /30 | 192.230.1.223 | 192.230.1.221 - 192.230.1.222 | 2 |
| A8 | 192.230.1.224 | /30 | 192.230.1.227 | 192.230.1.225 - 192.230.1.226 | 2 |
| A10 | 192.230.1.228 | /30 | 192.230.1.231 | 192.230.1.229 - 192.230.1.230 | 2 |
| A11 | 192.230.1.232 | /30 | 192.230.1.235 | 192.230.1.233 - 192.230.1.234 | 2 |
| A12 | 192.230.1.236 | /30 | 192.230.1.239 | 192.230.1.237 - 192.230.1.238 | 2 |

---
### Tree
![tree](treee.png)

## 🎯 Misi 1: Memetakan Medan Perang

### 1.1 Identifikasi Perangkat

Identifikasi perangkat sesuai dengan fungsinya dalam jaringan Aliansi:

#### 🖥️ Servers
- **Narya**: DNS Server (BIND9)
- **Vilya**: DHCP Server (isc-dhcp-server)
- **Palantir**: Web Server (Nginx)
- **IronHills**: Web Server (Apache2)

#### 🔀 DHCP Relay
- Rivendell
- AnduinBanks
- Minastir
- Wilderland

#### 💻 Clients dengan DHCP
- Khamul (5 host)
- Cirdan (20 host)
- Isildur (30 host)
- Durin (50 host)
- Gilgalad (100 host)
- Elendil (200 host)

---

### 1.2 VLSM Tree

Pohon subnet VLSM untuk jaringan `192.230.0.0/22`:
```

---

### 1.3 Konfigurasi Routing

Konfigurasi routing dilakukan pada setiap router untuk menghubungkan semua subnet.

#### 📍 Routing Table

**Osgiliath (Main Router)**
```bash
# Route ke subnet Moria (IronHills, Wilderland, Durin, Khamul)
route add -net 192.230.1.208/30 gw 192.230.1.218
route add -net 192.230.1.212/30 gw 192.230.1.218
route add -net 192.230.1.128/26 gw 192.230.1.218
route add -net 192.230.1.192/29 gw 192.230.1.218

# Route ke subnet Rivendell (Vilya, Narya)
route add -net 192.230.1.200/29 gw 192.230.1.222

# Route ke subnet Minastir
route add -net 192.230.0.0/24 gw 192.230.1.226
route add -net 192.230.1.228/30 gw 192.230.1.226
route add -net 192.230.1.232/30 gw 192.230.1.226
route add -net 192.230.1.236/30 gw 192.230.1.226
route add -net 192.230.1.0/25 gw 192.230.1.226
```

**Moria**
```bash
# Route ke Wilderland (Durin, Khamul)
route add -net 192.230.1.128/26 gw 192.230.1.214
route add -net 192.230.1.192/29 gw 192.230.1.214
```

**Minastir**
```bash
# Route ke Pelargir
route add -net 192.230.1.232/30 gw 192.230.1.230
route add -net 192.230.1.236/30 gw 192.230.1.230
route add -net 192.230.1.0/25 gw 192.230.1.230
```

**Pelargir**
```bash
# Route ke AnduinBanks
route add -net 192.230.1.0/25 gw 192.230.1.238
```

> **Note**: Semua konfigurasi lengkap ada di folder `config/`

---

### 1.4 Konfigurasi Service

#### A. DHCP Server (Vilya)

**Instalasi:**
```bash
apt-get update
apt-get install isc-dhcp-server -y
```

**Konfigurasi `/etc/dhcp/dhcpd.conf`:**
```bash
# Subnet A3 - Durin (50 host)
subnet 192.230.1.128 netmask 255.255.255.192 {
    range 192.230.1.129 192.230.1.190;
    option routers 192.230.1.129;
    option broadcast-address 192.230.1.191;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# Subnet A4 - Khamul (5 host)
subnet 192.230.1.192 netmask 255.255.255.248 {
    range 192.230.1.193 192.230.1.198;
    option routers 192.230.1.193;
    option broadcast-address 192.230.1.199;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# Subnet A9 - Elendil & Isildur (230 host)
subnet 192.230.0.0 netmask 255.255.255.0 {
    range 192.230.0.1 192.230.0.254;
    option routers 192.230.0.1;
    option broadcast-address 192.230.0.255;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}

# Subnet A13 - Gilgalad & Cirdan (120 host)
subnet 192.230.1.0 netmask 255.255.255.128 {
    range 192.230.1.1 192.230.1.126;
    option routers 192.230.1.1;
    option broadcast-address 192.230.1.127;
    option domain-name-servers 192.230.1.203;
    default-lease-time 600;
    max-lease-time 7200;
}
```

**Testing:**
```bash
# Di Vilya
service isc-dhcp-server status
cat /var/lib/dhcp/dhcpd.leases

# Di Client
ip addr show
cat /etc/resolv.conf
```

---

#### B. DHCP Relay

**Instalasi pada Rivendell, AnduinBanks, Minastir, Wilderland:**
```bash
apt-get update
apt-get install isc-dhcp-relay -y
```

**Konfigurasi `/etc/default/isc-dhcp-relay`:**
```bash
SERVERS="192.230.1.202"  # IP Vilya (DHCP Server)
INTERFACES="eth0 eth1 eth2"  # Sesuaikan dengan interface
OPTIONS=""
```

**Testing:**
```bash
# Cek relay berjalan
ps aux | grep dhcrelay | grep -v grep
service isc-dhcp-relay status
```

---

#### C. DNS Server (Narya)

**Instalasi:**
```bash
apt-get update
apt-get install bind9 -y
```

**Konfigurasi `/etc/bind/named.conf.options`:**
```bash
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
        8.8.8.8;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```

**Testing:**
```bash
# Di client
dig @192.230.1.203 google.com
nslookup google.com 192.230.1.203

# Di Narya
service bind9 status
ps aux | grep named
```

---

#### D. Web Server

**Palantir (Nginx)**
```bash
apt-get update
apt-get install nginx -y

# Edit /var/www/html/index.html
echo "Welcome to Palantir - Nginx Server" > /var/www/html/index.html

service nginx start
```

**IronHills (Apache)**
```bash
apt-get update
apt-get install apache2 -y

# Edit /var/www/html/index.html
echo "Welcome to IronHills - Apache Server" > /var/www/html/index.html

service apache2 start
```

**Testing:**
```bash
# Dari client
curl http://192.230.1.234  # Palantir
curl http://192.230.1.210  # IronHills
```
> **Note**: Semua konfigurasi lengkap ada di folder `setup/`
![topologi](1.44.png)
![topologi](1.444.png)

---

## 🔒 Misi 2: Menemukan Jejak Kegelapan

### 2.1 Routing dengan iptables (NAT)

**Soal:**
> Agar jaringan Aliansi bisa terhubung ke luar (Valinor/Internet), konfigurasi routing menggunakan iptables. **TIDAK DIPERBOLEHKAN** menggunakan MASQUERADE.

**Solusi:**

Pada router **Osgiliath**, konfigurasi NAT menggunakan SNAT (Source NAT):
```bash
# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Get IP address dari eth0 (interface ke Internet)
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Setup SNAT (BUKAN MASQUERADE)
iptables -t nat -A POSTROUTING -s 192.230.0.0/22 -o eth0 -j SNAT --to-source $ETH0_IP
```

**Penjelasan:**
- `SNAT` (Source NAT) mengubah source IP dari subnet internal (192.230.0.0/22) menjadi IP eth0
- Tidak menggunakan `MASQUERADE` sesuai instruksi
- IP forwarding harus di-enable agar packet bisa di-route

**Testing:**
```bash
# Dari client
ping 8.8.8.8
ping google.com

# Cek NAT table di Osgiliath
iptables -t nat -L -v -n
```

---

### 2.2 Blokir PING ke Vilya

**Soal:**
> Karena Vilya (DHCP) menyimpan data vital, pastikan tidak ada perangkat lain yang bisa melakukan PING ke Vilya. Namun, Vilya tetap leluasa dapat mengakses/ping ke seluruh perangkat lain.

**Solusi:**

Pada **Vilya**, tambahkan iptables rule:
```bash
# Blokir ICMP echo-request dari luar (orang lain ping ke Vilya)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Vilya masih bisa ping keluar (ICMP echo-reply boleh masuk)
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
```

**Penjelasan:**
- Rule pertama: DROP semua ICMP echo-request yang masuk (block incoming ping)
- Rule kedua: ACCEPT ICMP echo-request keluar (Vilya bisa ping ke luar)
- ICMP echo-reply tetap bisa masuk karena tidak di-block

**Testing:**
```bash
# Dari client (HARUS GAGAL)
ping 192.230.1.202
# Output: Request timeout atau Destination Host Unreachable

# Dari Vilya (HARUS BERHASIL)
ping 192.230.1.203  # Narya
ping 8.8.8.8        # Internet
```
![topologi](2.2.png)
![topologi](2.22.png)
---

### 2.3 Hanya Vilya yang Akses Narya

**Soal:**
> Agar lokasi pasukan tidak bocor, hanya Vilya yang dapat mengakses Narya (DNS). Gunakan `nc` (netcat) untuk memastikan akses port DNS (53) ini.

**Solusi:**

Pada **Narya**, tambahkan iptables rule:
```bash
# Allow dari Vilya (192.230.1.202) untuk port 53
iptables -A INPUT -p tcp --dport 53 -s 192.230.1.202 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -s 192.230.1.202 -j ACCEPT

# Block dari yang lain
iptables -A INPUT -p tcp --dport 53 -j DROP
iptables -A INPUT -p udp --dport 53 -j DROP
```

**Penjelasan:**
- DNS menggunakan port 53 (TCP & UDP)
- Rule pertama: Hanya IP Vilya yang boleh akses port 53
- Rule kedua: Block semua IP lain yang coba akses port 53

**Testing:**
```bash
# Dari Vilya (HARUS BERHASIL)
nc -zv 192.230.1.203 53
# Output: Connection to 192.230.1.203 53 port [tcp/domain] succeeded!

# Dari client lain (HARUS GAGAL)
nc -zv 192.230.1.203 53
# Output: Connection refused atau timeout
```

> **Note**: Hapus aturan ini setelah testing agar internet lancar untuk install paket
![topologi](2.3.png)
![topologi](2.33.png)

---
# 2.4  IronHills Weekend Access Control

## 📌 Deskripsi
Blokir akses HTTP ke IronHills kecuali hari Sabtu/Minggu untuk subnet tertentu.

## 🎯 Subnet yang Diizinkan
| Node | Subnet | Waktu |
|------|--------|-------|
| Durin | 192.230.1.128/26 | Weekend |
| Khamul | 192.230.1.192/29 | Weekend |
| Elendil & Isildur | 192.230.0.0/24 | Weekend |

## 🚀 Script
```bash
#!/bin/bash

# Install dependencies
apt-get install -y iptables apache2 xtables-addons-common
systemctl restart apache2

# Reset rules
iptables -F

# Basic rules
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Weekend-only HTTP access
iptables -A INPUT -p tcp --dport 80 -s 192.230.1.128/26 -m time --weekdays Sat,Sun -j ACCEPT  # Durin
iptables -A INPUT -p tcp --dport 80 -s 192.230.1.192/29 -m time --weekdays Sat,Sun -j ACCEPT  # Khamul
iptables -A INPUT -p tcp --dport 80 -s 192.230.0.0/24 -m time --weekdays Sat,Sun -j ACCEPT    # Elendil & Isildur

# Block semua HTTP lainnya
iptables -A INPUT -p tcp --dport 80 -j DROP

echo "✅ Firewall configured!"
```

## 🧪 Testing
```bash
# Test GAGAL (Rabu)
date -s "2025-11-27 12:00:00"
curl http://192.230.x.x  # Timeout/refused

# Test SUKSES (Sabtu)
date -s "2025-11-30 12:00:00"
curl http://192.230.x.x  # Apache page muncul
```

## 📊 Verifikasi
```bash
# Lihat rules
iptables -L INPUT -n -v

# Cek modul time
lsmod | grep xt_time
```

![topologi](2.4.png)

### 2.5 Port Scan Detection (Palantir)

**Soal:**
> Pasukan Manusia (Elendil) diminta menguji keamanan Palantir. Lakukan simulasi port scan dengan nmap rentang port 1-100.
> a. Web server harus memblokir scan port yang melebihi 15 port dalam waktu 20 detik.
> b. Penyerang yang terblokir tidak dapat melakukan ping, nc, atau curl ke Palantir.
> c. Catat log iptables dengan prefix "PORT_SCAN_DETECTED".

**Solusi:**

Pada **Palantir**, konfigurasi firewall untuk mendeteksi dan memblokir port scanner:

```bash
# 1. Buat Chain PORTSCAN
iptables -N PORTSCAN
iptables -A PORTSCAN -m limit --limit 2/min -j LOG --log-prefix "PORT_SCAN_DETECTED: " --log-level 4
iptables -A PORTSCAN -j DROP

# 2. Whitelist Established Connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# 3. Logic Deteksi ( > 15 hits dalam 20 detik)
iptables -A INPUT -p tcp --syn -m recent --name SCANNER_LIST --update --seconds 20 --hitcount 15 -j PORTSCAN
iptables -A INPUT -p tcp --syn -m recent --name SCANNER_LIST --set
```

**Testing:**
```bash
# Dari Elendil (Penyerang)
nmap -p 1-100 192.230.1.234

# Hasil: Port filtered / Host seems down
# Cek log di Palantir: dmesg | tail
```

---

### 2.6 Connection Limiting (IronHills)

**Soal:**
> Hari Sabtu tiba. Akses ke IronHills dibatasi untuk mencegah overload.
> Akses ke IronHills hanya boleh berasal dari 3 koneksi aktif per IP dalam waktu bersamaan.

**Solusi:**

Pada **IronHills**, batasi jumlah koneksi per IP saat akhir pekan:

```bash
# Set waktu ke Sabtu (Testing)
date -s "2023-12-02 12:00:00"

# Allow Established (Optimasi)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Logic ConnLimit (Max 3 koneksi pada Sabtu/Minggu)
iptables -A INPUT -p tcp --syn --dport 80 -m time --weekdays Sat,Sun -m connlimit --connlimit-above 3 -j REJECT

# Allow Normal Traffic (untuk request < 3)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

**Testing:**
```bash
# Dari Durin (Client)
ab -n 100 -c 10 http://192.230.1.210/

# Hasil: Failed requests karena connection refused (REJECT)
```

---

### 2.7 Traffic Redirection (Sihir Hitam)

**Soal:**
> Selama uji coba, terdeteksi anomali. Setiap paket yang dikirim Vilya menuju Khamul, ternyata dibelokkan oleh sihir hitam menuju IronHills.

**Solusi:**

Pada **Vilya**, gunakan DNAT pada chain OUTPUT (karena trafik berasal dari server itu sendiri):

```bash
# Target: Traffic ke Subnet Khamul (192.230.1.192/29)
# Redirect ke: IronHills (192.230.1.210)

iptables -t nat -A OUTPUT -d 192.230.1.192/29 -p tcp --dport 80 -j DNAT --to-destination 192.230.1.210:80
```

**Testing:**
```bash
# Dari Vilya
curl -I http://192.230.1.193  # Salah satu IP Khamul

# Hasil: Mendapat response dari IronHills (Server: Apache/IronHills)
```

---

## 🚧 Misi 3: Isolasi Sang Nazgûl

**Soal:**
> Mengetahui pengkhianatan Khamul, Aliansi mengambil langkah final: Blokir semua lalu lintas masuk dan keluar dari Khamul.
> **Penting:** Yang diblokir adalah Khamul (5 Host), BUKAN Durin (50 Host).

**Solusi:**

Implementasi dilakukan di Router **Wilderland** (Gateway terdekat bagi Khamul & Durin):

```bash
# Enable IP Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# 1. Allow DHCP (Agar client tetap dapat IP)
iptables -I FORWARD -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# 2. Blokir Total Subnet Khamul
iptables -I FORWARD 2 -s 192.230.1.192/29 -j DROP
iptables -I FORWARD 3 -d 192.230.1.192/29 -j DROP
```

**Testing:**
```bash
# Dari Khamul:
ping 192.230.1.202 (Vilya) -> GAGAL (RTO)

# Dari Durin (Tetangga):
ping 192.230.1.202 (Vilya) -> BERHASIL (Reply)
```


