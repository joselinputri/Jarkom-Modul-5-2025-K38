auto eth0
iface eth0 inet static
    address 192.230.1.229
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.230.1.226
    netmask 255.255.255.252
    gateway 192.230.1.225
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward

auto eth2
iface eth2 inet static
    address 192.230.0.1
    netmask 255.255.255.0
    up route add -net 192.230.1.232 netmask 255.255.255.252 gw 192.230.1.230
    up route add -net 192.230.1.236 netmask 255.255.255.252 gw 192.230.1.230
    up route add -net 192.230.1.0 netmask 255.255.255.128 gw 192.230.1.230