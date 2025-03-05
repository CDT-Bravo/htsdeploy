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
# apt-get install nano apache php libapache2-mod-php

# #Set up files
# echo "[*] Setting up html directory"
# cp characters.html /var/www/html/characters.html
# cp characters.json /var/www/html/characters.json
# cp get_characters.html /var/www/html/get_characters.php     # ALL THIS IS TESTING RN
# cp index.html /var/www/html/index.html
# cp save_character.html /var/www/html/save_character.php
# cp quest.php /var/www/html/quest.php

# #restart apache
# echo "[*] Restarting apache2"
# systemctl restart apache2


#ONLY REQUIRED IF YOU WANT OLD APACHE
apt-get install -y git build-essential ufw nano libapr1-dev libaprutil1-dev wget

#download build file
echo "[*] Downloading build file"
wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
tar -xvzf httpd-2.4.49.tar.gz
cd httpd-2.4.49

./configure --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-mpm=event
make
make install