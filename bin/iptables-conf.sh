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

# redirect ns*.linode.com to PowerDNS
iptables \
    -A PREROUTING -t nat -p udp \
    --source $ns1,$ns2,$ns3 \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 53

## redirect all non-ns*.linode.com traffic to gg.nix.is
iptables \
    -A PREROUTING -t nat -p udp \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 5252
