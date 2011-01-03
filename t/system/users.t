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

    # Skip root
    next if $user eq "root";

    # Skip the leech user
    next if $user eq "leech";

    # Make sure we have a Real Name
    my ($name, undef, undef, undef, $other) = split /,/, $gecos;
    ok($name, "User $user has a defined name");

    # Make sure we have an E-Mail forwarding address
    my ($alias, $email) = qx[grep "$user\@w.nix.is" /etc/postfix/virtual] =~ /^(\S+) \s+ (\S+)$/x;
    if ($user !~ /^(?: v-perlbrew | failo | smolder | postgres )$/x) {
        no warnings 'uninitialized';
        ok($email, "We have an E-Mail $email under the alias $alias for user $user");
    }
}
