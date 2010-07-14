#!/usr/bin/env perl
use 5.012;
use Test::More tests => 2;

chomp(my ($kernel, $root) = qx[ ack '^kernel\\s*(\\S+) root=(/dev\\S+)' --output='\$1\\n\$2' /boot/grub/menu.lst ]);

ok(-f $kernel, "current kernel image $kernel exists");
ok(-b $root, "current root device $root exists");
