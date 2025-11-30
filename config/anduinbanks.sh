auto eth0
iface eth0 inet static
    address 192.230.1.1
    netmask 255.255.255.128

auto eth1
iface eth1 inet static
    address 192.230.1.238
    netmask 255.255.255.252
    gateway 192.230.1.237
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward