#!/bin/bash

apt-get update -y
apt-get upgrade -y

apt install apache2 -y
ufw allow 'Apache'
apt install php libapache2-mod-php php-mysql -y
systemctl restart apache2
apt install adminer -y
a2enconf adminer
systemctl restart apache2
echo "<?php phpinfo(); ?>" > /var/www/html/index.php