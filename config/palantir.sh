auto eth1
iface eth1 inet static
    address 192.230.1.234
    netmask 255.255.255.252
    gateway 192.230.1.233
    up echo nameserver 192.168.122.1 > /etc/resolv.conf