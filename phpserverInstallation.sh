#!/bin/bash

user=`echo $USER`

`which apache2ctl >> tempApache`
a=`wc -l tempApache | tr -s " " | cut -d " " -f 1`
if [ $a -lt  0 ]
then
  
  echo "apache not installed"
apt-get update
apt-get -y install apache2
/etc/init.d/apache2 restart
fi


`which php >> tempPhp`
b=`wc -l tempPhp | tr -s " " | cut -d " " -f 1`
if [ $b -lt  0 ]
then
  echo "php not installed"
apt-get -y install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-mysql
fi


`dpkg --get-selections | grep phpmyadmin >> tempPhpmyadminCheck`
b=`wc -l tempPhpmyadminCheck | tr -s " " | cut -d " " -f 1`
if [ $b -gt  0 ]
then
   echo "installed"
else
   echo "phpmyadmin not installed"
echo '<?php phpinfo(); ?>' >/var/www/html/phpinfo.php
   sudo apt-get install debconf-utils
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mvixusa'
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mvixusa'
   sudo apt-get -y install mysql-server

echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' |sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password mvixusa' |sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password mvixusa' |sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password mvixusa' |sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

sudo apt-get -y install phpmyadmin

    sudo service apache2 restart;
exit 0
fi






