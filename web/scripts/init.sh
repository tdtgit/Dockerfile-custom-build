#!/bin/bash

export $(cat /.env | xargs) && echo "Exporting ENV done"

chown -R apache: /var/www/html

# Change default docker.local hostname to domain
sed -i "s/docker\.local/$VIRTUAL_HOST/g" /etc/httpd/conf.d/vhosts.conf
# Start Apache
/usr/sbin/httpd

# Config PHP so they can get ENV variables
echo "clear_env = no" >> /etc/php-fpm.d/www.conf
mkdir -p /run/php-fpm
/usr/sbin/php-fpm

/bin/bash