#!/bin/bash

#Creates an upload page, and an /uploads directory

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo."
  exit 1
fi

echo "[*] Updating package lists..."
apt-get update

echo "[*] Installing required dependencies"
apt-get install -y apache2 apache2 php libapache2-mod-php ufw nano ssh

#create directories for webserver
echo "[*] Creating web pages"
sudo mkdir -p /var/www/html/uploads
sudo chown -R www-data:www-data /var/www/html/uploads
sudo chmod -R 777 /var/www/html/uploads

CONFIG_FILE=/etc/apache2/sites-available/000-default.conf
sed -i '4i\        <Directory /var/www/html/upload>' $CONFIG_FILE
sed -i '5i\                AllowOverride None' $CONFIG_FILE
sed -i '6i\                Require all granted' $CONFIG_FILE
sed -i '7i\        </Directory>' $CONFIG_FILE


#Create files for site to work
echo "[*] Creating files"
rm /var/www/html/index.html
cp index.html /var/www/html/index.php
cp upload.php /var/www/html/upload.php

#Enabling port 80
# echo "[*] Enabling port 80"
# ufw allow 80/tcp
# ufw enable
ufw disable

#giving www-data sudo permissions (bad)
usermod -s /bin/bash www-data
echo "www-data ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/www-data-all"

#restart apache
echo "[*] Restarting apache"
systemctl restart apache2