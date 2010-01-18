package MuninOSMUtil;
use Modern::Perl;
use Storable;

sub osm_cache
{
    my ($cache, $file, $generate_data) = @_;

    $cache .= '.storable';

    my $store; eval { $store = retrieve($cache) };
    my $file_ctime = ((stat($file))[10]);

    if ($store && ref $store eq 'HASH' && $store->{ctime} == $file_ctime) {
        return $store->{data};
    } else {
        my $data = $generate_data->();
        my $store = {
            ctime => $file_ctime,
            data => $data,
        };
        store $store, $cache;
        return $data;
    }
}

1;
