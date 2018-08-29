FROM centos:7
RUN yum update -y
RUN yum install -y httpd php-fpm php php-mysql
COPY vhosts /etc/httpd/conf.d/
COPY www /var/www/html/
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
ENTRYPOINT [ "/scripts/init.sh" ]