First we start the Database server

`docker run -it --name db1 --privileged --rm -p 3306:3306 dbserver`

Then we will start the Nginx proxy (as Load balancer)

`docker run -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro -e VIRTUAL_HOST=web.local --name pr --rm jwilder/nginx-proxy`

Finally we will start the Web server as many as we want

`docker run -it --privileged --rm --link db1 -d webserver`
