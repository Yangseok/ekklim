#!/bin/sh
docker build -t web:0.1 .
docker run -d -p 80:80 -p 443:443 --name web -v /home/nginx/conf:/etc/nginx/conf.d  -v /home/nginx/log:/var/log/nginx -v /home/webuser:/home web:0.1 nginx -g 'daemon off;'
