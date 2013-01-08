#!/usr/bin/env perl
use v5.12;
use strict;
use warnings;
use Test::More 'no_plan';

chomp(my @uid = qx[cut -d: -f3 /etc/passwd]);

for my $passwd_uid (@uid) {
    my ($user, $password, $uid, $gid, undef, undef, $gecos, $homedir, $shell) = getpwuid($passwd_uid);

    # Skip non-normal users
    next unless $shell eq "/bin/bash";

    # Skip these users
    pass "skipping $user", next if $user ~~ [ qw( root leech debian-tor ) ];

    # Make sure we have a Real Name
    my ($name, undef, undef, undef, $other) = split /,/, $gecos;
    ok($name, "User $user has a defined name");

    # Make sure we have an E-Mail forwarding address
    my ($alias, $email) = qx[grep "$user\@u.nix.is" /etc/postfix/virtual] =~ /^(\S+) \s+ (\S+)$/x;
    if ($user !~ /^(?: v-perlbrew | failo | smolder | postgres | passenger)$/x) {
        no warnings 'uninitialized';
        ok($email, "We have an E-Mail $email under the alias $alias for user $user");
    }
}
