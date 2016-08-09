FROM nola.kr:5000/web:0.1
MAINTAINER ysl8607@naver.com

ADD ./nginx.conf /etc/nginx/nginx.conf

VOLUME /var/log/nginx
VOLUME /home

CMD nginx -g 'daemon off;'

EXPOSE 80
EXPOSE 443
