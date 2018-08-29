FROM centos:7
RUN yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y pwgen
RUN yum install -y mysql mysql-community-server
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
ENTRYPOINT [ "/scripts/init.sh" ]