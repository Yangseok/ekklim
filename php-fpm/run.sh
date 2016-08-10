#!/bin/sh
docker build -t was:0.1 .
docker run -v /home/php-fpm/log:/var/log/php-fpm -d -p 9090:9090 --name was was:0.1 php-fpm -F
