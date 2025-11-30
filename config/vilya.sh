auto eth1
iface eth1 inet static
    address 192.230.1.202
    netmask 255.255.255.248
    gateway 192.230.1.201
    up echo nameserver 192.168.122.1 > /etc/resolv.conf