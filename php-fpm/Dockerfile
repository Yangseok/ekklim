FROM nola.kr:5000/common:0.4
MAINTAINER ysl8607@naver.com

ADD ./php.ini /etc/php.ini
ADD ./php-fpm.conf /etc/php-fpm.conf
ADD ./www.conf /etc/php-fpm.d/www.conf


VOLUME /var/log/php-fpm

CMD ["php-fpm -F"]

EXPOSE 9090
