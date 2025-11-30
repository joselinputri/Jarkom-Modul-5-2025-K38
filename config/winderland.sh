auto eth1
iface eth1 inet static
    address 192.230.1.129
    netmask 255.255.255.192

auto eth2
iface eth2 inet static
    address 192.230.1.193
    netmask 255.255.255.248

auto eth3
iface eth3 inet static
    address 192.230.1.214
    netmask 255.255.255.252
    gateway 192.230.1.213
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward