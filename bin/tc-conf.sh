#!/bin/sh

# Outgoing interface
DEV=eth0

# Speed of outgoing interface
LINERATE="1000Mbit"

# Reset
tc qdisc del dev $DEV root 2> /dev/null

# Set linerate
tc qdisc add dev $DEV root handle 1: cbq avpkt 1000 bandwidth $LINERATE

# Throttle Freenet's Opennet
OPENNET_THROTTLEPORT=14324
OPENNET_THROTTLERATE=16Kbit
tc  class add dev $DEV parent 1: classid 1:1 cbq rate $OPENNET_THROTTLERATE allot 1500 prio 5 bounded isolated
tc filter add dev $DEV parent 1: protocol ip prio 16 u32 match ip sport $OPENNET_THROTTLEPORT 0xffff flowid 1:1
