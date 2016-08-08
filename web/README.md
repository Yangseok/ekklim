docker build -t web:0.1 . OR docker pull nola.kr:5000/web:0.1 

docker run --name nginx -d -p 80:80 -p 443:443 -v /root/data:/data web:0.1 nginx -g 'daemon off;'
