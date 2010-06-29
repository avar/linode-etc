#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use Test::More;

my ($ip)   = qx[ /sbin/ifconfig eth0 | grep 'inet addr' ] =~ m[inet addr:(\S+)];
chomp(my (@list) = qx[wget -q 'https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$ip' -O- | grep -v '^#' ]);

plan tests => scalar @list;

cmp_ok $_, 'ne', $ip, "$_ is not $ip" for @list;



