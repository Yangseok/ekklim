FROM nola.kr:5000/web:0.1
MAINTAINER ysl8607@naver.com

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

VOLUME ["/data", "/etc/nginx/conf.d", "/var/log/nginx"]

WORKDIR /etc/nginx

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
