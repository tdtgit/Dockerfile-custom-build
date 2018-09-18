#!/bin/bash

function generate_pw(){
    pwgen -scny -r "\"'$,[]*?{}~#%\<>|^;" -1 16;
}

mv /etc/my.cnf /etc/my.cnf.original
echo "[mysqld]" >> /etc/my.cnf
echo "default-authentication-plugin=mysql_native_password" >> /etc/my.cnf
echo "datadir=/var/lib/mysql" >> /etc/my.cnf
echo "log-error=/var/log/mysqld.log" >> /etc/my.cnf
echo "pid-file=/var/run/mysqld/mysqld.pid" >> /etc/my.cnf
echo "socket=/var/sock/mysql/mysql.sock" >> /etc/my.cnf

setcap -r /usr/sbin/mysqld # https://bugs.mysql.com/bug.php?id=91395

function start(){
    mysqld_pre_systemd
    mysqld --datadir=/var/lib/mysql --socket=/var/lib/mysql/mysql.sock --user=root -D
}

if [ -d "/var/lib/mysql" ] && [ "$( ls -A "/var/lib/mysql" )" ]; then
    echo "A database instance already exists. Please use old credentical instead new one."

    start
else
    ROOTPASS=${MYSQL_ROOT_PASSWORD:-$(generate_pw)}
    echo "Root password: $ROOTPASS"
    USER=${MYSQL_USERNAME:-argus}
    USERPASS=${MYSQL_PASSWORD:-$(generate_pw)}
    echo "User: $USER / Password: $USERPASS"
    DBNAME=${MYSQL_DBNAME:-newdb}
    echo "Created database: $DBNAME"

    start

    # Change root password
    mysqladmin -u root -p$(grep 'temporary password' /var/log/mysqld.log | awk '{print $13}') password "$ROOTPASS" && \
    # Create database
    mysql -uroot -p$ROOTPASS -e "CREATE DATABASE $DBNAME" && \
    # Create user account
    mysql -uroot -p$ROOTPASS -e "CREATE USER '$USER'@'%' IDENTIFIED WITH mysql_native_password BY '$USERPASS'" && \
    # Grant privileges
    mysql -uroot -p$ROOTPASS -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$USER'@'%'" && \
    mysql -uroot -p$ROOTPASS -e "flush privileges;"

    mysqladmin -u root -p$ROOTPASS shutdown

    mysqld --datadir=/var/lib/mysql --socket=/var/lib/mysql/mysql.sock --user=root
fi

/bin/bash