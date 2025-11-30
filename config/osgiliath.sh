auto eth0
iface eth0 inet dhcp
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
    up echo 1 > /proc/sys/net/ipv4/ip_forward
    up ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    up iptables -t nat -A POSTROUTING -s 192.230.0.0/22 -o eth0 -j SNAT --to-source $ETH0_IP

auto eth1
iface eth1 inet static
    address 192.230.1.225
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 192.230.1.217
    netmask 255.255.255.252
    up route add -net 192.230.1.208 netmask 255.255.255.252 gw 192.230.1.218
    up route add -net 192.230.1.212 netmask 255.255.255.252 gw 192.230.1.218
    up route add -net 192.230.1.128 netmask 255.255.255.192 gw 192.230.1.218
    up route add -net 192.230.1.192 netmask 255.255.255.248 gw 192.230.1.218

auto eth3
iface eth3 inet static
    address 192.230.1.221
    netmask 255.255.255.252
    up route add -net 192.230.1.200 netmask 255.255.255.248 gw 192.230.1.222
    up route add -net 192.230.0.0 netmask 255.255.255.0 gw 192.230.1.226
    up route add -net 192.230.1.228 netmask 255.255.255.252 gw 192.230.1.226
    up route add -net 192.230.1.232 netmask 255.255.255.252 gw 192.230.1.226
    up route add -net 192.230.1.236 netmask 255.255.255.252 gw 192.230.1.226
    up route add -net 192.230.1.0 netmask 255.255.255.128 gw 192.230.1.226