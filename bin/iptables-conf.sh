#!/bin/sh

# Flush everything
iptables -F 
iptables -t nat -F

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

## first we redirect ns*.linode.com to the real DNS server

# LOG it:

# iptables -A INPUT -j LOG --source ns1.linode.com,ns2.linode.com,ns3.linode.com,ns4.linode.com,ns5.linode.com --log-level 4

iptables \
    -A PREROUTING -t nat -p udp \
    --source ns1.linode.com,ns2.linode.com,ns3.linode.com,ns4.linode.com,ns5.linode.com \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 53

## Then we direct everyone else to the tunnel

iptables \
    -A PREROUTING -t nat -p udp \
    --destination 109.74.193.250 --dport 53 \
    -j REDIRECT \
    --to-ports 1234
