#!/bin/sh

# Flush everything
iptables -F 
iptables -t nat -F

# OpenVPN routing, see /etc/openvpn/README.mkdn
iptables -t nat -A POSTROUTING -s 10.9.8.0/24 -o eth0 -j MASQUERADE
