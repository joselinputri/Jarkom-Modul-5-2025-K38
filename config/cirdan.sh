auto eth1
iface eth1 inet static
    address 192.230.1.3
    netmask 255.255.255.128
    gateway 192.230.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf