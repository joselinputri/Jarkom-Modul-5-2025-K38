auto eth0
iface eth0 inet static
    address 192.230.1.230
    netmask 255.255.255.252
    gateway 192.230.1.229
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward

auto eth1
iface eth1 inet static
    address 192.230.1.237
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 192.230.1.233
    netmask 255.255.255.252
    up route add -net 192.230.1.0 netmask 255.255.255.128 gw 192.230.1.238