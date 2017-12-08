#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#A tool to auto-compile & install Nginx+MySQL+PHP on Centos7 for laster stable version"
#BY:Mr lile  Date:2017/12/8    version:1.0

#soft download dir 
DIR=/usr/local/src

read  -t 30  -p  "Are you sure want to install LNMP,please input Y/N."  lnmp   

if [ "$lnmp" == "y" ]
then 
echo -e "lnmp will be install" >> /usr/local/src/lnmp.log
else
exit
fi

read -t 30 -p  "please enter the mysql passwd.(Default password: root)"   mysqlrootpwd

if [  -z "$mysqlrootpwd"  ]
then 
                        mysqlrootpwd="root"
echo  "MySQL root password:root"
fi

read -t 30 -p  "please enter the PHP version.(Default version: 7.2.0)"   phpversion

if [  -z "$phpversion"  ]
then 
                         phpversion="7.2.0"
echo  "PHP version:7.2.0"
fi


yum -y autoremove httpd*
yum -y autoremove php*
yum -y autoremove mysql*

yum -y install epel-release.noarch

yum -y install firewalld

yum -y install wget gcc gcc-c++ make cmake  perl autoconf automake libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses ncurses-devel curl curl-devel openssl openssl-devel pcre pcre-devel libtool  pcre-devel libaio-devel libaio bzip2-devel libcurl-devel gd-devel bison bison-devel  libmcrypt libmcrypt-devel

yum update  -y


cd $DIR
wget http://us2.php.net/distributions/php-$phpversion.tar.gz 

tar xf php-$phpversion.tar.gz

echo ""
echo "===================nginx will be install ============================"
echo ""

sleep 5;

rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

yum -y install nginx

echo "===================Nginx  install completed ========================="
echo ""


echo ""
echo "===================yum install mysql============================"
echo ""

sleep 5;

cat > /etc/yum.repos.d/MariaDB.repo<<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum install -y MariaDB-server MariaDB-client

systemctl start mysql

cat > /tmp/mysql_sec_script<<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$mysqlrootpwd';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$mysqlrootpwd';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$mysqlrootpwd';
use mysql;
delete from user where password="";
flush privileges;
EOF

/usr/bin/mysql  < /tmp/mysql_sec_script

rm -rf /tmp/mysql_sec_script


echo ""
echo "============================MySQL  install completed============="
echo ""

sleep 5;


echo ""
echo "===================php will be install ========================="
echo ""

sleep 5;

cd $DIR
cd php-$phpversion/

./configure  --prefix=/usr/local/php --exec-prefix=/usr/local/php  --bindir=/usr/local/php/bin  --sbindir=/usr/local/php/sbin  --includedir=/usr/local/php/include --libdir=/usr/local/php/lib/php  --mandir=/usr/local/php/php/man  --with-config-file-path=/usr/local/php/etc  --with-mysql-sock=/var/lib/mysql/mysql.sock  --with-mcrypt  --with-mhash  --with-openssl  --with-mysqli=shared,mysqlnd  --with-pdo-mysql=shared,mysqlnd  --without-sqlite3 --without-pdo-sqlite --with-gd  --with-iconv  --with-zlib  --enable-zip  --enable-inline-optimization  --disable-debug  --disable-rpath  --enable-shared  --enable-xml  --enable-bcmath  --enable-shmop  --enable-sysvsem  --enable-mbregex  --enable-mbstring  --enable-ftp  --enable-gd-native-ttf  --enable-pcntl  --enable-sockets  --with-xmlrpc --enable-soap  --without-pear  --with-gettext  --enable-session  --with-curl  --with-jpeg-dir  --with-freetype-dir  --enable-opcache  --enable-fpm --with-fpm-user=nobody  --with-fpm-group=nobody  --without-gdbm  --enable-fast-install --disable-fileinfo && make && make install

if [  $? -ne 0 ]
then
                  echo -e "PHP  install filed\n" >> /usr/local/src/lnmp.log
         exit
fi

cp sapi/fpm/php-fpm.service /usr/lib/systemd/system/
cp php.ini-production /usr/local/php/etc/php.ini
cd /usr/local/php/etc
cp php-fpm.conf.default php-fpm.conf
cd php-fpm.d
cp www.conf.default www.conf


cat > /usr/local/nginx/html/info.php<<EOF
<?php
phpinfo();
?>
EOF

echo "================LNMP install  is ok,now start LNMP and enable LNMP ======================="
echo ""
systemctl enable nginx.service
systemctl enable mariadb.service
systemctl enable php-fpm.service

/usr/bin/systemctl restart php-fpm
/usr/bin/systemctl restart nginx
/usr/bin/systemctl restart mysql

echo "================set firewalld default 80  22======================="

systemctl restart firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload


echo ""
echo "============LNMP install  is ok, The path of some dirs:=============="

echo ""
echo "The path of some dirs:"
echo "mysql conf file :   /etc/my.cnf"
echo "php install dir :     /usr/local/php"
echo "php conf file :     /usr/local/php/etc/php.ini"
echo "nginx conf file :   /etc/nginx.conf and /etc/nginx/conf.d/"
echo "web dir :     /usr/local/nginx/html"
echo "The mysql root passwd is : $mysqlrootpwd" 
echo "please input http://ip/info.php, to checkout the lnmp is working!!!"
echo "Enjoy it !"

exit
