auto eth1
iface eth1 inet static
    address 192.230.1.194
    netmask 255.255.255.248
    gateway 192.230.1.193
    up echo nameserver 192.168.122.1 > /etc/resolv.conf