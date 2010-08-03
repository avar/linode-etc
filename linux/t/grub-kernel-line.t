#!/usr/bin/env perl
use 5.012;
use strict;
use autodie;
use Test::More tests => 2;

open my $menu, "<", "/boot/grub/menu.lst";

while (my $line = <$menu>) {
    next unless $line ~~ m[^ kernel \s* (?<image>\S+) \s+ root=(?<device>/dev\S+) ]x;

    ok(-f $+{image},  "current kernel image $+{image} exists");
    ok(-b $+{device}, "current root device $+{device} exists");
}
