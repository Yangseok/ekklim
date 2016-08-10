#!/bin/sh
docker build -t was:0.1 .
docker run -i -t -v /home/php-fpm/log:/var/log/php-fpm -d -p 9090:9090 --name was was:0.1 /bin/bash
docker exec was php-fpm
