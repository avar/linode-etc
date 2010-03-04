#!/bin/bash

# This will all happen eventually. But if you want a new domain
# distributed *now* then run this script.

echo "Reloading PowerDNS"
/etc/init.d/pdns reload

echo "Notifying slaves"
/etc/bind/bin/notify-slaves.sh

sleep=30
echo "Sleeping for $sleep secs before running tests on us/slaves:"
sleep $sleep

echo "Running domain tests:"
perl /etc/bind/t/gen.PL
prove -j 10 -r /etc/bind/t/

