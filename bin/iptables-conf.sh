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
### NSTX (IP-over-DNS)
###

# This is a setup for a IP-over-DNS tunnel. See
# http://thomer.com/howtos/nstx.html

## Redirect ns*.linode.com to the real DNS server, they're our slaves
ns1=69.93.127.10
ns2=65.19.178.10
ns3=75.127.96.10
ns4=207.192.70.10
ns5=109.74.194.10

# redirect ns*.linode.com to PowerDNS
iptables \
    -A PREROUTING -t nat -p udp \
    --source $ns1,$ns2,$ns3,$ns4,$ns5 \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 53

## redirect all non-ns*.linode.com traffic to tunnel.nix.is
iptables \
    -A PREROUTING -t nat -p udp \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 5252

# redirect avar's strange web requests to port 80
iptables \
    -A PREROUTING -t nat -p tcp \
    --source 94.216.112.136 \
    --destination 109.74.193.250 --dport 1234 \
    -j REDIRECT \
    --to-ports 80
