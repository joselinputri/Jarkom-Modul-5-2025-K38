auto eth1
iface eth1 inet static
    address 192.230.1.209
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 192.230.1.218
    netmask 255.255.255.252
    gateway 192.230.1.217
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward

auto eth3
iface eth3 inet static
    address 192.230.1.213
    netmask 255.255.255.252
    up route add -net 192.230.1.128 netmask 255.255.255.192 gw 192.230.1.214
    up route add -net 192.230.1.192 netmask 255.255.255.248 gw 192.230.1.214