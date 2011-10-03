<VirtualHost *:81>
              ServerName fjandinn.com
              ServerAlias www.fjandinn.com
              DocumentRoot /var/www/fjandinn.com
</VirtualHost>
