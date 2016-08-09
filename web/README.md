useradd webuser

chmod 755 /home/webuser
chmod 755 /home/webuser/ekklim7

cd /home/webuser/ekklim7
svn co <repository 주소>

chmod 700 run.sh

./run.sh
