#!/bin/bash

function generate_pw(){
    pwgen -scny -r "\"'$,[]*?{}~#%\<>|^;" -1 16;
}

ROOTPASS=${MYSQL_ROOT_PASSWORD:-$(generate_pw)}
echo "Root password: $ROOTPASS"

USER=${MYSQL_USERNAME:-argus}
USERPASS=${MYSQL_PASSWORD:-$(generate_pw)}
echo "User: $USER / Password: $USERPASS"

DBNAME=${MYSQL_DBNAME:-newdb}
echo "Created database: $DBNAME"

perl -i -pe "BEGIN{undef $/;} s/^\[mysqld\]$/[mysqld]\n\ndefault-authentication-plugin=mysql_native_password\n/sgm" /etc/my.cnf

mysqld_pre_systemd && \
mysqld --user=root -D && \
# Change root password
mysqladmin -u root -p$(grep 'temporary password' /var/log/mysqld.log | awk '{print $13}') password "$ROOTPASS" && \
# Create database
mysql -uroot -p$ROOTPASS -e "CREATE DATABASE $DBNAME" && \
# Create user account
mysql -uroot -p$ROOTPASS -e "CREATE USER '$USER'@'%' IDENTIFIED WITH mysql_native_password BY '$USERPASS'" && \
# Grant privileges
mysql -uroot -p$ROOTPASS -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$USER'@'%'" && \
mysql -uroot -p$ROOTPASS -e "flush privileges;" && \
/bin/bash