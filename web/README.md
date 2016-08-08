docker build -t web:0.1 .
docker run --name nginx -d -p 80:80 -v /root/data:/data web:0.1
