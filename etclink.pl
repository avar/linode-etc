#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw<abs_path getcwd>;
use File::Spec::Functions qw<catpath splitpath>;
use FindBin qw<$Script>;
use Getopt::Long qw<:config auto_help bundling>;
use Pod::Usage;

our $VERSION = '0.01';

GetOptions(
    'n|dry-run' => \my $dry_run,
    'f|force'   => \my $force,
    'v|version' => sub { print "etclink.pl version $VERSION\n"; exit },
) or pod2usage();

my $source = defined $ARGV[0] ? abs_path($ARGV[0]) : getcwd();
my $dest = '/etc';
my $self = $Script;

die "Source dir cannot be '$dest'" if $source =~ m{^$dest/?$};
chdir $source or die "Couldn't chdir to '$source'";
my @files = split /\n/, qx{find \\( -type f -o -type l \\) ! -regex '^./.git/.*'|cut -b3-};

for my $file (@files) {
    next if $file eq $self;

    if (-l $file && -l "$dest/$file") {
        # skip if it's a symlink which is already in place
        next if readlink($file) eq readlink("$dest/$file");
    }

    if (!-l $file && -l "$dest/$file" && stat "$dest/$file") {
        # skip if it's file that has already been symlinked
        next if (stat "$dest/$file")[1] == (stat $file)[1];
    }
    
    if (-e "$dest/$file" || -l "$dest/$file") {
        if (!$force) {
            $dry_run
                ? print "--force is off, would not overwrite '$dest/$file'\n"
                : print "--force is off, not overwriting '$dest/$file'\n"
            ;
            next;
        }
        
        if ($dry_run) {
            print "Would overwrite '$dest/$file'\n";
            next;
        }
        else {
            print "Overwriting '$dest/$file'\n";
            if (!unlink "$dest/$file") {
                warn "Can't remove '$dest/$file': $!\n";
                next;
            }
        }
    }
    else {
        $dry_run
            ? print "Would create '$dest/$file'\n"
            : print "Creating '$dest/$file'\n"
        ;
    }
    
    next if $dry_run;

    my $path = catpath((splitpath("$dest/$file"))[0,1]);
    if (!-d $path) {
        eval { make_path($path) };
        if ($@) {
            warn "Failed to create dir '$path': $@\n";
            next;
        }
    }

    my $success = -l $file
        ? symlink readlink($file), "$dest/$file"
        : symlink "$source/$file", "$dest/$file"
    ;

    warn "Can't create '$dest/$file': $!\n" if !$success;
}

=head1 NAME

etclink.pl - Creates/copies symlinks to your /etc dir for all the files
in a specified directory.

=head1 SYNOPSIS

B<etclink.pl> [options] [DIR]

 Options:
  -n, --dry-run    Don't actually do anything
  -f, --force      Removes already existing files if found
  -h, --help       Display this help message
  -v, --version    Display version information

DIR is the directory containing the files you want to link / symlinks you
want to copy. Defaults to the current directory.

=head1 AUTHOR

Hinrik E<Ouml>rn SigurE<eth>sson, hinrik.sig@gmail.com

=head1 LICENSE AND COPYRIGHT

Copyright 2009 Hinrik E<Ouml>rn SigurE<eth>sson

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
