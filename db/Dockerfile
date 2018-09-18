FROM centos:7
RUN yum update -y && yum install -y epel-release
RUN yum install -y pwgen

RUN rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
RUN yum-config-manager --disable mysql55-community && \
	yum-config-manager --disable mysql56-community && \
	yum-config-manager --disable mysql57-community && \
	yum-config-manager --enable mysql80-community && \
	yum clean all

RUN yum install -y mysql-community-server

RUN yum clean all && \
    yum -y autoremove && \
    yum clean metadata && \
    rm -rf /var/cache/yum

ADD scripts /scripts
RUN chmod +x /scripts/*.sh

ENV MYSQL_USERNAME=env \
    MYSQL_PASSWORD=SecurePW123@FromENV \
    MYSQL_DBNAME=db_prod

ENTRYPOINT [ "/bin/bash", "-c", "/scripts/init.sh" ]
EXPOSE 3306