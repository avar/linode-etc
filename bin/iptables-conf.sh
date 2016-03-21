#!/bin/sh

# Flush everything
iptables -F 
iptables -t nat -F

## Logging

## Logging
# log everything
#iptables -A INPUT -j LOG --log-level 4

# OpenVPN routing, see /etc/openvpn/README.mkdn
iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o eth0 -j MASQUERADE

###
### iodine (IP-over-DNS)
###

# This is a setup for a IP-over-DNS tunnel using iodine. Since we run
# a shadow master that Linode's DNS servers talk to on 0.0.0.0:53 we
# use iptables to pass Linode traffic through, and send everything
# else to iodine at port 53.

# For reference: https://wiki.koumbit.net/DnsTunnel

## Redirect hetzner nameservers to the real DNS server, they're our
## slaves
ns1=ns1.first-ns.de.
ns2=robotns2.second-ns.de.
ns3=robotns3.second-ns.com.
nsdebug=140.211.15.157

# redirect ns*.linode.com to PowerDNS
for proto in tcp udp
do
    iptables \
        -A PREROUTING -t nat -p $proto \
        --source $ns1,$ns2,$ns3,$nsdebug \
        --destination 5.9.157.150 --dport 53 \
        -j DNAT \
        --to-destination 127.0.0.1:53
done

## redirect all non-ns*.linode.com traffic to gg.nix.is
iptables \
    -A PREROUTING -t nat -p udp \
    --destination 5.9.157.150 --dport 53 \
    -j REDIRECT \
    --to-ports 5252


### Tor transparent proxying ###
# Forbid the user 'david-tor' from making any direct internet
# connections, and instead hijack them and route over Tor.

#iptables -t nat -A OUTPUT ! -o lo -p tcp -m owner --uid-owner david_tor -m tcp -j REDIRECT --to-ports 9040
#iptables -t nat -A OUTPUT -p udp -m owner --uid-owner david_tor -m udp --dport 53 -j REDIRECT --to-ports 9053
#iptables -t filter -A OUTPUT -p tcp -m owner --uid-owner david_tor -m tcp --dport 9040 -j ACCEPT
#iptables -t filter -A OUTPUT -p udp -m owner --uid-owner david_tor -m udp --dport 9053 -j ACCEPT
#iptables -t filter -A OUTPUT ! -o lo -m owner --uid-owner david_tor -j DROP

# Now done in userspace, just make sure david_tor can't connect to non-localhost
iptables -I OUTPUT -m owner --uid-owner david_tor ! -o lo -j DROP


