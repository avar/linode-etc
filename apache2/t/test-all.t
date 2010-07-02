#!/usr/bin/env perl
use perl5i::latest;
use Test::More;
use Test::WWW::Mechanize;

my @tests = (
    'awstats.nix.is'     => qr/Awstats/,
    'blog.nix.is'        => qr/literal thoughts/,
    'ci.nix.is'          => qr/Powered by phpBB/,
    'downlode.org'       => qr/downlode/,
    'git.nix.is'         => qr/GitHub/,
    'hailo.nix.is'       => qr/Hailo Chat/,
    'hailo.org'          => qr/Hailo is a a pluggable/,
    'leech.nix.is'       => qr/wTorrent/,
    'lists.nix.is'       => qr/Mailman/,
    'munin.nix.is'       => qr/Munin/,
    'nix.is'             => qr/logo\.png/,
    'noc.nix.is'         => qr/Network operations/,
    'osm.nix.is'         => qr/Garmin map of Iceland/,
    'tumi.nix.is'        => qr/Tumi/,
    'v.nix.is'           => qr/vee nix/,
    'vnstat.nix.is'      => qr/vnstat\.cgi/,
    'voodootronix.com'   => qr/voodootronix/,
    'xn--var-xla.net'    => qr/Bjarmason/,
    'velfag.is'          => qr/MediaWiki/,
    'www.velfag.is'      => qr/MediaWiki/,
    'xn--vlfag-bsa.is.'  => qr/MediaWiki/,
    'www.xn--vlfag-bsa.is.' => qr/MediaWiki/,
);

plan tests => scalar @tests;

my $mech = Test::WWW::Mechanize->new(
    agent => __FILE__
);

while (my ($site, $content_like) = splice @tests, 0, 2) {
    $site = "http://$site/";
    $mech->get_ok( $site );
    $mech->content_like( $content_like, "$site has content like $content_like");
}

