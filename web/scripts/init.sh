#!/bin/bash

/usr/sbin/httpd

mkdir -p /run/php-fpm
/usr/sbin/php-fpm --daemonize

/bin/bash