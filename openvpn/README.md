# OpenVPN server setup

Authentication-related parts of the server config
(`/etc/openvpn/tun0.conf` in our case):

    # multi-user setup with certs and TLS auth
    server 10.9.8.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    tls-server
    tls-auth ta.key
    dh dh1024.pem
    key server.key
    cert server.crt
    ca ca.crt

Now, we must generate a few files. Follow the instructions in
[the OpenVPN CA multi-client howto](http://openvpn.net/index.php/open-source/documentation/howto.html#pki).

You have to change a few parameters in a file called `vars` and then
run scripts which generate the relevant files. Our changes to the
original Debian files in
`/usr/share/doc/openvpn/examples/easy-rsa/2.0/` are:
    
    -export KEY_COUNTRY="US"
    -export KEY_PROVINCE="CA"
    -export KEY_CITY="SanFrancisco"
    -export KEY_ORG="Fort-Funston"
    -export KEY_EMAIL="me@myhost.mydomain"
    +export KEY_COUNTRY="IS"
    +export KEY_PROVINCE="IS"
    +export KEY_CITY="Reykjavik"
    +export KEY_ORG="nix.is"
    +export KEY_EMAIL="hostmaster@nix.is"

Once you've run the scripts according to the aforementioned
documentation, you should have `dh1024.pem`, `server.key`,
`server.crt`, and `ca.crt`, in addition to some client keys and
certs. Put them all (except the client files) in
`/etc/openvpn/keys`.

The `tun0.conf` file has to reference these files, from our config:
    
    tls-auth keys/ta.key
    dh       keys/dh1024.pem
    key      keys/server.key
    cert     keys/server.crt
    ca       keys/ca.crt
    
The only remaining file is the TLS auth key. Generate it:

    openvpn --genkey --secret /etc/openvpn/ta.key

Now you have to have done this (perhaps in a script that runs on
boot):

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o eth0 -j MASQUERADE

Then start openvpn:

    service openvpn start

# GUI client network-manager setup

Get the server's ca.crt and ta.key, in addition to your user's cert and key.
Then set things up like this in GNOME's NetworkManager.

![Main VPN screen in NetworkManager](http://github.com/avar/linode-etc/raw/master/openvpn/vpn-networkmanager-main.png)
![Advanced VPN screen in NetworkManager](http://github.com/avar/linode-etc/raw/master/openvpn/vpn-networkmanager-advanced.png)
![TLS auth screen in NetworkManager](http://github.com/avar/linode-etc/raw/master/openvpn/vpn-networkmanager-tls-auth.png)

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

