auto eth2
iface eth2 inet static
    address 192.230.0.2
    netmask 255.255.255.0
    gateway 192.230.0.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf