service mysql start

# Config Access
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Generate website folder
mkdir /var/www/raccoman && touch /var/www/raccoman/index.php
echo "<?php phpinfo(); ?>" >> /var/www/raccoman/index.php

# SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/raccoman.pem -keyout /etc/nginx/ssl/raccoman.key -subj "/C=IT/ST=Rome/L=Rome/O=42 School/OU=raccoman/CN=raccoman/"

# Config NGINX
cp ./tmp/nginx-conf /etc/nginx/sites-available/raccoman
ln -s /etc/nginx/sites-available/raccoman /etc/nginx/sites-enabled/raccoman
rm -rf /etc/nginx/sites-enabled/default

# Config MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# Download phpmyadmin
mkdir /var/www/raccoman/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/raccoman/phpmyadmin
mv ./tmp/phpmyadmin.inc.php /var/www/raccoman/phpmyadmin/config.inc.php

# Download wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/raccoman
mv /tmp/wp-config.php /var/www/raccoman/wordpress

# Change to home directory
cd /home/

service php7.3-fpm start
service nginx start
bash
