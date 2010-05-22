# OpenVPN setup

On v, as documented
[on the debian wiki](http://wiki.debian.org/HowTo/openvpn):

    cd /etc/openvpn
    openvpn --genkey --secret static.key

On the client, in `/etc/openvpn/tun0.conf`:

    remote v.nix.is
    dev tun0
    ifconfig 10.9.8.X 10.9.8.1
    secret static.key
    
Replace `X` with some number, e.g. `3`, `1` is v, `2` is avar's
laptop.
