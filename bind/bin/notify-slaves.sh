#!/bin/bash

# Send NOTIFY requests to our slaves to tell them our domain(s) changed

for domain in $(ls /etc/bind/master/master* | perl -pe 's/.*master\.//');
do
    echo Sending NOTIFY to $domain
    pdns_control notify $domain
done
