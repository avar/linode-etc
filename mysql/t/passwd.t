#!/usr/bin/env perl
use strict;
use warnings;
use Test::More 'no_plan';
use File::stat;

my @users = qw[ root vf_user hinrik ];

my %cfg = (
    root => {
        user => 'root',
        group => 'root',
        mode => 0600,
    },
    www => {
        user => 'www-data',
        group => 'www-data',
        mode => 0660,
    },
);

check('root', $cfg{root});
check($_, $cfg{www}) for qw[ vf_user hinrik ];

sub check {
    my ($user, $cfg) = @_;
    my $file = "/etc/mysql/passwd/$user";
    ok(-f $file, "Password for $user exists at $file");
    my $stat = stat $file;
    cmp_ok($stat->mode & 07777, '==', $cfg->{mode}, sprintf "$user owns its password with mode %o", $cfg->{mode});
    my $uid = ((getpwnam($cfg->{user}))[2]);
    my $gid = ((getpwnam($cfg->{group}))[3]);
    cmp_ok($stat->uid, '==', $uid, "$user\'s password is owned by $cfg->{user}");
    cmp_ok($stat->gid, '==', $gid, "$user\'s password is owned by $cfg->{group}");
}
