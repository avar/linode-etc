#!/usr/bin/env perl
use v5.12;
use strict;
use warnings;
use Test::More qw(no_plan);

my $lines = get_auth_log_lines();
my @dpkg_i = dpkg_installed();
my @deb_packages = deb_packages();
chomp(my @ignore_list = <DATA>);

my @install;
my %who_installed;
my @remove;

for my $line (@$lines) {
    given ($line) {
        when (m[(?<user>\S+) : TTY.*?COMMAND=/usr/bin/(?<command>aptitude|apt-get) install (?<package>\S+)]) {
            push @install => $+{package};
            $who_installed{ $+{package} } = $+{user};
        }
        when (m[(?<user>\S+) : TTY.*?COMMAND=/usr/bin/(?<command>aptitude|apt-get) remove (?<package>\S+)]) {
            push @remove => $+{package};
        }
    }
}

my $ok = 1;
my %fail;
for my $installed (@install) {
    my $was_removed = $installed ~~ @remove;
    my $dpkg_installed = $installed ~~ @dpkg_i;

    if ($was_removed and $dpkg_installed and
        # Special cases for special people
        $installed ne 'libmagickcore3') {
        warn "We think $installed was removed, but it's currently installed says dpkg. This might be a problem.";
    }

    if (not $was_removed and $dpkg_installed and
        not (grep { $_ eq $installed } @deb_packages) and
        not (grep { $_ eq $installed } @ignore_list)) {
        my $user = $who_installed{$installed};
        push @{ $fail{ $user } } => $installed;
        $ok = 0;
    }
}

for my $user (sort keys %fail) {
    subtest "$user knows how to install packages" => sub {
        fail "$user installed $_ but didn't add it to /etc/deb-packages" for sort @{ $fail{$user} };
        done_testing();
    };
}

pass("Everything we've installed is either ignored or listed in /etc/deb-packages") if $ok;

sub get_auth_log_lines {
    my @logs = (
        reverse(glob("/var/log/auth.log.*gz")),
        "/var/log/auth.log"
    );

    my @lines;

    for my $log (@logs) {
        my $cmd;
        given ($log) {
            when (/\.gz/) { $cmd = "zcat" }
            default       { $cmd = "cat" }
        }
        chomp(my @all = qx[$cmd $log]);
        push @lines => @all;
    }

    return \@lines;
}

sub dpkg_installed {
    chomp(my @dpkg = qx[dpkg -l | grep ^ii | awk '{print \$2}']);
    @dpkg;
}

sub deb_packages {
    chomp(my @deb = qx[grep -h -v -e ^# -e ^\$ -e ':' /etc/deb-packages]);
    @deb;
}

# Add packages to ignore here
__DATA__
