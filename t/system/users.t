#!/usr/bin/env perl
use v5.12;
use strict;
use warnings;
use Test::More;

chomp(my @uid = qx[cut -d: -f3 /etc/passwd]);

for my $passwd_uid (@uid) {
    my ($user, $password, $uid, $gid, undef, undef, $gecos, $homedir, $shell) = getpwuid($passwd_uid);

    # Skip non-normal users
    next unless $shell eq "/bin/bash";

    # Skip root
    next if $user eq "root";

    # Skip the leech user
    next if $user eq "leech";

    my ($name, undef, undef, undef, $other) = split /,/, $gecos;
    ok($name, "User $user has a defined name");
}
