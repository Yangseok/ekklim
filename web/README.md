docker build -t web:0.1 . OR docker pull nola.kr:5000/web:0.1 

docker run -v /home/web/conf:/etc/nginx/conf.d  -v /home/web/log:/var/log/nginx -d -p 80:80 -p 443:443 --name web nola.kr:5000/web:0.1 nginx -g 'daemon off;'
