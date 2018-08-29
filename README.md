Start Webserver

`docker run -it --name web1 --privileged --rm -p 80:80 --link db1 webserver`

Start Dbserver

`docker run -it --name db1 --privileged --rm -e MYSQL_USERNAME=tdtgit -e MYSQL_PASSWORD="MySecurePW123@" -p 3306:3306 dbserver`
