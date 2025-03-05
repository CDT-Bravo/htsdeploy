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
apt-get install -y git build-essential ufw nano libapr1-dev libaprutil1-dev wget libpcre3-dev libssl-dev libapache2-mod-php php

#download build file
echo "[*] Downloading build file"
wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
tar -xvzf httpd-2.4.49.tar.gz
cd httpd-2.4.49

./configure --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-mpm=event
make
make install

echo "[*] Setting up html directory"
cp characters.html /usr/local/apache2/htdocs/characters.html
cp characters.json /usr/local/apache2/htdocs/characters.json
cp get_characters.html /usr/local/apache2/htdocs/get_characters.php
cp index.html /usr/local/apache2/htdocs/index.html
cp save_character.html /usr/local/apache2/htdocs/save_character.php
cp quest.php /usr/local/apache2/htdocs/quest.php
cp debug.log /usr/local/apache2/htdocs/debug.log
