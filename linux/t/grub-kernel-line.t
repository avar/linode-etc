#!/usr/bin/env perl
use 5.012;
use strict;
use autodie;
use Test::More tests => 4;

open my $menu, "<", "/boot/grub/menu.lst";

my (@grub_kernels, @generated_kernels);
while (my $line = <$menu>) {
    next unless $line ~~ m[^ kernel \s* (?<image>\S+) \s+ root=(?<device>\S+) ]x;
    my ($image, $device) = @+{qw(image device)};

    if ($device ~~ m[^/dev]) {
        push @grub_kernels => $image;
        ok(-f $image,  "current kernel image $image exists");
        ok(-b $device, "current root device $device exists");
    } else {
        push @generated_kernels => $image;
    }
}

# Check that we've updated menu.lst to reference our latest kernel
chomp(my @kernels = reverse split /\s+/, qx[ ls --sort=version /etc/boot/vmlinuz-* ]);
my $latest = $kernels[0];
ok($latest ~~ @grub_kernels, "Our latest kernel $latest is listed among the grub kernels: <@grub_kernels>");

# Check that we've run `update-grub`
subtest "We ran update-grub" => sub {
    plan tests => @generated_kernels + 1;

    pass "Got generated kernel: $_" for @generated_kernels;

    ok($latest ~~ @generated_kernels, "Our latest kernel $latest is listed among the generated kernels ^^");
};
