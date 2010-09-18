# iodine server

We run an [iodine](http://code.kryo.se/iodine/) IPv4 over DNS server
on `v`. This is useful for:

 * Getting past a paywall on wifi networks that require payment.
 
   Most of these have a working DNS server, but intercept all other
   requests. If you can make DNS requests you can usually use the
   Internet with iodine.

 * Defeating bandwidth or rate limits on a regular network (not
   recommended).
   
   Some networks place a limit on the amount of non-local traffic you
   can use monthly, or rate limit traffic outside their
   network. However they usually don't limit outgoing requests from
   their DNS server in the same manner. So sometimes:
   
    You <-> DNS server <-> Internet <-> iodine tunnel <-> Internet   
    
   Is faster than:
   
    You <-> Internet

   Note that doing this may incite a BOFH pitchfork attack aimed at
   your derriere.

# iodine client

You need to have some forethought and do most of this before you need
to use `iodine`. So set this up today:

## Installing the client

We use `iodined` version 6 [from Debian](packages.debian.org/iodine)
on `v`. As of writing
[the latest Ubuntu](http://packages.ubuntu.com/search?keywords=iodine)
only has version 5. If you have version 6 you can just:

    sudo aptitude install iodine
    
If you don't you need to:

 * Get the source on `v`:
 
    ssh v
    cd /tmp
    apt-get source iodine
    exit

 * Compile it on your computer:    
    
    cd /tmp
    scp v:/tmp/iodine-* .
    cd iodine-*
    dpkg-buildpackage -rfakeroot -uc -b
    
 * Install it:
 
    cd /tmp
    sudo dpkg -i iodine_*deb
    
## Grab the password from v

If you're in the `adm` group on v you can do:

    ssh v "cat /etc/iodine/passwd/iodine" > ~/.iodine-password
    
## Start the client

Now when you're on a restricted network you can just do either:

Use this if you can make direct external DNS requests, e.g. if this
works:

    $ dig +short @ns1.linode.com v.nix.is A
    109.74.193.250
    
You should be able to do:

    sudo iodine -P "$(cat ~/.iodine-password)" gg.nix.is
    
Otherwise if you can't make external DNS requests you might have to go
through a local DNS server, usually the first entry in
`/etc/resolv.conf`:

    sudo iodine -P "$(cat ~/.iodine-password)" "$(grep ^nameserver /etc/resolv.conf | awk '{print $2}' | head -n1)" gg.nix.is
    
## Test the client

You should now have a `dns0` interface in `sudo ifconfig`:
    
    $ sudo ifconfig dns0
    dns0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
              inet addr:10.0.0.2  P-t-P:10.0.0.2  Mask:255.255.255.224
              UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1130  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:500 
              RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
              
You should also have noe extra route set up, i.e. if you used this
before:

    $ sudo route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    192.168.2.0     0.0.0.0         255.255.255.0   U     2      0        0 wlan0
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 wlan0
    0.0.0.0         192.168.2.1     0.0.0.0         UG    0      0        0 wlan0

Your routing table should now be:

    $ sudo route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    10.0.0.0        0.0.0.0         255.255.255.224 U     0      0        0 dns0
    192.168.2.0     0.0.0.0         255.255.255.0   U     2      0        0 wlan0
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 wlan0
    0.0.0.0         192.168.2.1     0.0.0.0         UG    0      0        0 wlan0
    
You should be able to ping `v`, which is at `10.0.0.1`:

    $ ping -c 3 10.0.0.1
    PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
    64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=47.9 ms
    64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=45.3 ms
    64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=49.1 ms
    
    --- 10.0.0.1 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2002ms
    rtt min/avg/max/mdev = 45.307/47.487/49.181/1.618 ms

And SSH to it:

    $ ssh 10.0.0.1
    Perl 5 is some guys wearing bras dancing in spandex.
    v ~ (master) $

And of course do things like set up a SOCKS proxy through ssh:
    
    $ ssh -D 9999 10.0.0.1
    The lulz expands consciousness. The lulz is vital to every heist.
    v ~ (master) $

I haven't been able to connect to the VPN server on v. Connecting to
`10.0.0.1` directly doesn't work, and forwarding the VPN port to
`localhost` from `10.0.0.1` will ruin the routing table.

There are probably some options to work around both of those that I
haven't explored yet.
