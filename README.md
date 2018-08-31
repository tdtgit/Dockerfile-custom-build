Start Webserver

`docker run -it --name web1 --privileged --rm -p 80:80 --link db1 webserver`

Start Dbserver

`docker run -it --name db1 --privileged --rm -p 3306:3306 dbserver`
