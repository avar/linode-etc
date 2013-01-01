<VirtualHost *:80>
    ServerName voodootronix.com
    ServerAlias www.voodootronix.com
    DocumentRoot /var/www/voodootronix.com

    <FilesMatch "\.(ico|jpg|jpeg|gif|png|css|js)$">
        ExpiresActive on  
        ExpiresDefault "access plus 11 days"
    </FilesMatch>

    <Directory /var/www/voodootronix.com/images/>
        Options +ExecCGI
        AddHandler cgi-script .cgi
    </Directory>

</VirtualHost>
