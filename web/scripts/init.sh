#!/bin/bash

# Change default docker.local hostname to domain

# Generate a self signed certificate if no valid cert exists.
if [ ! -e /etc/ssl/$VIRTUAL_HOST.key ] && [[ ! -e /etc/ssl/$VIRTUAL_HOST.key ]]; then

    if [ ! -d /etc/ssl/ ]; then
        mkdir -p /etc/ssl/
    fi

    echo "Certificate not found, creating self signed..."

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/$VIRTUAL_HOST.key -out /etc/ssl/$VIRTUAL_HOST.crt -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=$VIRTUAL_HOST" &> /dev/null

    sed -i "s/docker\.local:80/$VIRTUAL_HOST:443/g" /etc/httpd/conf.d/vhosts.conf
    # sed -i "s/docker\.local/$VIRTUAL_HOST:443/g" /etc/httpd/conf.d/vhosts.conf

    sed -i '/DocumentRoot/a SSLEngine on\n\tSSLCertificateFile /etc/ssl/'"$VIRTUAL_HOST"'.crt\n\tSSLCertificateKeyFile /etc/ssl/'"$VIRTUAL_HOST"'.key' /etc/httpd/conf.d/vhosts.conf
fi

# Start Apache
chown -R apache: /var/www/html
/usr/sbin/httpd

# Config PHP so they can get ENV variables
echo "clear_env = no" >> /etc/php-fpm.d/www.conf
mkdir -p /run/php-fpm
/usr/sbin/php-fpm -F -R