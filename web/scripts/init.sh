#!/bin/bash

/usr/sbin/httpd

echo "clear_env = no" >> /etc/php-fpm.d/www.conf
mkdir -p /run/php-fpm
/usr/sbin/php-fpm

/bin/bash