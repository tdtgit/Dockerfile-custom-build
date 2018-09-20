#!/bin/bash

function setup_ssl(){
    echo "Setting SSL"

    if [ ! -e /etc/ssl/$VIRTUAL_HOST.key ] && [[ ! -e /etc/ssl/$VIRTUAL_HOST.crt ]]; then

        if [ ! -d /etc/ssl/ ]; then
            mkdir -p /etc/ssl/
        fi

        echo -e "<VirtualHost *:80>\n\tServerName $VIRTUAL_HOST\nRedirect / https://$VIRTUAL_HOST/\n</VirtualHost>" >> /etc/httpd/conf.d/vhosts-force-ssl.conf

        echo "Certificate not found, creating self signed..."

        openssl req -sha256 -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/$VIRTUAL_HOST.key -out /etc/ssl/$VIRTUAL_HOST.crt -subj "/CN=$VIRTUAL_HOST" &> /dev/null

        sed -i "s/*:80/*:443/g" /etc/httpd/conf.d/vhosts.conf
        sed -i "s/docker\.local/$VIRTUAL_HOST/g" /etc/httpd/conf.d/vhosts.conf

        sed -i '/DocumentRoot/a SSLEngine on\n\tSSLProtocol All -SSLv2 -SSLv3\n\tSSLCertificateFile /etc/ssl/'"$VIRTUAL_HOST"'.crt\n\tSSLCertificateKeyFile /etc/ssl/'"$VIRTUAL_HOST"'.key' /etc/httpd/conf.d/vhosts.conf
    else
        echo "Certificate found, using it."
        sed -i "s/docker\.local:80/$VIRTUAL_HOST:443/g" /etc/httpd/conf.d/vhosts.conf
        sed -i "s/docker\.local/$VIRTUAL_HOST/g" /etc/httpd/conf.d/vhosts.conf
        sed -i '/DocumentRoot/a SSLEngine on\n\tSSLCertificateFile /etc/ssl/'"$VIRTUAL_HOST"'.crt\n\tSSLCertificateKeyFile /etc/ssl/'"$VIRTUAL_HOST"'.key' /etc/httpd/conf.d/vhosts.conf
    fi
}

if [ -n $SSL ]
then
  if [ "$SSL" = "1" ]
  then
    setup_ssl
  fi
fi

# Start Apache
chown -R apache: /var/www/html
/usr/sbin/httpd

# Config PHP so they can get ENV variables
echo "clear_env = no" >> /etc/php-fpm.d/www.conf
mkdir -p /run/php-fpm
/usr/sbin/php-fpm

if [ -n $SSL ]
then
  if [ "$SSL" = "1" ]
  then
    yum install -y epel-release
    cd /etc/yum.repos.d && wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo
    # When all thing is up
    sed -i '/tSSLCertificateKeyFile/a SSLOpenSSLConfCmd DHParameters "/etc/ssl/certs/dhparam.pem"' /etc/httpd/conf.d/vhosts.conf
    
    openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    /usr/sbin/httpd -k restart
  fi
fi



/bin/bash