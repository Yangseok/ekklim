docker build -t web:0.1 . OR docker pull nola.kr:5000/web:0.1 

docker run -d -p 80:80 -p 443:443 --name web -v /home/web/conf:/etc/nginx/conf.d  -v /home/web/log:/var/log/nginx -v /home/web/data:/home nola.kr:5000/web:0.1 nginx -g 'daemon off;'

svn co <repository 주소>

