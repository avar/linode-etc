<VirtualHost *:80>
    ServerName goosegoosego.com
    ServerAlias www.goosegoosego.com

    <Location />
        SetHandler perl-script
        PerlHandler Plack::Handler::Apache2
        PerlSetVar psgi_app /home/avar/g/gist-ggg/ggg.pl
    </Location>

    CustomLog /dev/null common
</VirtualHost>
