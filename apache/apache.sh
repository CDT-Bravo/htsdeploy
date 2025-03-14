#!/bin/bash

#configure vulnerable apache webserver

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo."
  exit 1
fi

#Download dependencies
echo "[*] Updating package lists..."
apt-get update

echo "[*] Installing required dependencies"
#ONLY REQUIRED IF YOU WANT OLD APACHE
apt-get install -y git build-essential ufw nano libapr1-dev libaprutil1-dev wget libpcre3-dev libssl-dev #libapache2-mod-php php

#download build file
echo "[*] Downloading build file"
wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
tar -xvzf httpd-2.4.49.tar.gz
cd httpd-2.4.49

./configure --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-mpm=event
make
make install

#download php from source
echo "[*] Setting up php"
sudo apt install libxml2-dev libsqlite3-dev libcurl4-openssl-dev libonig-dev zlib1g-dev pkg-config -y
cd /usr/local/src
sudo wget https://www.php.net/distributions/php-8.1.0.tar.gz
sudo tar -xzf php-8.1.0.tar.gz
cd php-8.1.0

sudo ./configure --with-apxs2=/usr/local/apache2/bin/apxs --with-mysqli --enable-mbstring --enable-xml --enable-cgi
sudo make -j$(nproc)
sudo make install

#add module to config file
echo "LoadModule php_module modules/libphp.so
AddHandler application/x-httpd-php .php
DirectoryIndex index.php index.html" >> /usr/local/apache2/conf/httpd.conf

#create apache sudo user
useradd -m -s /bin/bash apache
echo "apache ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

NEW_USER="apache"
sed -i "s/^User .*/User $NEW_USER/" /usr/local/apache2/conf/httpd.conf
sed -i "s/^Group .*/Group $NEW_USER/" /usr/local/apache2/conf/httpd.conf

echo "[*] Setting up html directory"
sudo cp characters.html /usr/local/apache2/htdocs/characters.html
sudo cp characters.json /usr/local/apache2/htdocs/characters.json
sudo cp get_characters.php /usr/local/apache2/htdocs/get_characters.php
sudo cp index.html /usr/local/apache2/htdocs/index.html
sudo cp save_character.php /usr/local/apache2/htdocs/save_character.php
sudo cp quest.php /usr/local/apache2/htdocs/quest.php
sudo cp debug.log /usr/local/apache2/htdocs/debug.log

#remove error message
echo "ServerName=127.0.0.1" >> /usr/local/apache2/conf/httpd.conf

#restart apache service
/usr/local/apache2/bin/apachectl restart