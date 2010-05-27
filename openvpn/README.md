# OpenVPN server setup

On v, as documented
[on the debian wiki](http://wiki.debian.org/HowTo/openvpn), generate a
secret key:

    openvpn --genkey --secret static.key
    
Then start openvpn:

    sudo service openvpn start
    
First you have to have done this somewhere:

    echo 1 > /proc/sys/net/ipv4/ip_forward
    sudo iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o eth0 -j MASQUERADE
    
# GUI client network-manager setup

Copy v's `/etc/openvpn/static.key` to your own
`/etc/openvpn/static.key` (or somewhere else secure). Then set things
up like this in GNOME's NetworkManager. Adjusting `Local IP Address`
to something else:

![OpenVPN setup with NetworkManager](http://github.com/avar/linode-etc/raw/master/openvpn/v.nix.is-vpn-network-manager.png)

Now you should be able to start the VPN connection and ping v:

    $ ping -c 1 10.9.8.1
    PING 10.9.8.1 (10.9.8.1) 56(84) bytes of data.
    64 bytes from 10.9.8.1: icmp_seq=1 ttl=64 time=85.7 ms
    
And ping your client from v:
    
    $ ping -c 1 10.9.8.2
    PING 10.9.8.2 (10.9.8.2) 56(84) bytes of data.
    64 bytes from 10.9.8.2: icmp_seq=1 ttl=64 time=45.1 ms
    
And your routes will look something like this:
    
    $ route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    109.74.193.250  192.168.2.1     255.255.255.255 UGH   0      0        0 wlan0
    # The important bit, all traffic through the VPN
    10.9.8.1        0.0.0.0         255.255.255.255 UH    0      0        0 tun0
    ...
    
# Manual client setup

tun0.conf`:

    remote v.nix.is
    dev tun0
    ifconfig 10.9.8.X 10.9.8.1
    secret static.key
    
Replace `X` with some number, e.g. `3`, `1` is v, `2` is avar's
laptop.