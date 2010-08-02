package WebTest;
use 5.10.0;
use strict;
use Test::More;
use Test::WWW::Mechanize;

sub new {
    my ($class, %args) = @_;

    my $self = {
         %args,
    };

    bless $self => $class;
}

sub run_tests {
    my ($self) = @_;

    my $domain       = $self->{domain};
    my $content_like = $self->{content_like};

    plan( tests => 2 );

    my $mech = Test::WWW::Mechanize->new(
        agent => __FILE__
    );

    my $site = "http://$domain/";
    $mech->get_ok( $site );
    $mech->content_like( $content_like, "$site has content like $content_like");

    return;
}

sub run_todo_test {
    my ($self) = @_;

    my $domain       = $self->{domain};
    plan( skip_all => "No tests for domain or alias $domain yet" );
    return;
}

1;
