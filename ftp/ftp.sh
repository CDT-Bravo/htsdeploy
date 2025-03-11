#!/bin/bash

#enables unsafe options for vsftpd

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo."
  exit 1
fi

echo "[*] Updating package lists..."
apt-get update

echo "[*] Installing required dependencies"
apt-get install -y git build-essential ufw nano ssh

#get vulnerable package
echo "[*] Downloading vsftpd-2.3.4"
git clone https://github.com/nikdubois/vsftpd-2.3.4-infected

#make package using build-essential
echo "[*] Building vsftpd"
cd vsftpd-2.3.4-infected

MAKEFILE="Makefile"
if [ ! -f "$MAKEFILE" ]; then
    echo "Makefile not found"
    exit 1
fi

sed -i '/^LIBS/s/$/ -lcrypt/' "Makefile"
make

#cover some base requirements by vsftpd
echo "[*] Setting up required dependencies"
mkdir /usr/share/empty
cp vsftpd /usr/local/sbin/vsftpd
cp vsftpd.conf.5 /usr/local/man/man5
cp vsftpd.8 /usr/local/man/man8
cp vsftpd.conf /etc

#Create ftp usr, and directory to store files for hints
mkdir /var/ftp
useradd -d /var/ftp ftp
chown root.root /var/ftp
chmod og-w /var/ftp

#open port 21
# echo "[*] Opening port 21/tcp"
# ufw allow 21/tcp
# ufw allow 1000:10100/tcp #seems to be a werid passive issue, not sure if this is required yet
# ufw enable
ufw disable

#Modify vsftpd config file
# 1. Enable anonymous login
# 2. Enable write_enable
# 3. Enable anon_upload_enable
# 4. Enable anon_mkdir_write_enable
# 5. Enable local user login
# 6. Disable Chroot
# 7. Add home path of /var/ftp
# 8. Enable passive mode for fixing some bugs
# 9. Enable anonymous manipulation of directories
# 10. Change upload permissions for all users
CONFIG_FILE="/etc/vsftpd.conf"
echo "[*] Modifying config file: $CONFIG_FILE"

sed -i 's/^#*\(anonymous_enable=\).*/\1YES/' $CONFIG_FILE
sed -i 's/^#*\(write_enable=\).*/\1YES/' $CONFIG_FILE
sed -i 's/^#*\(anon_upload_enable=\).*/\1YES/' $CONFIG_FILE
sed -i 's/^#*\(anon_mkdir_write_enable=\).*/\1YES/' $CONFIG_FILE
sed -i 's/^#*\(local_enable=\).*/\1YES/' $CONFIG_FILE
sed -i 's/^#*\(chroot_local_user=\).*/\1NO/' $CONFIG_FILE
echo "anon_root=/var" >> $CONFIG_FILE
echo "pasv_enable=YES" >> $CONFIG_FILE
echo "pasv_min_port=10000" >> $CONFIG_FILE
echo "pasv_max_port=10100" >> $CONFIG_FILE
echo "anon_other_write_enable=YES" >> $CONFIG_FILE
echo "anon_mkdir_write_enable=YES" >> $CONFIG_FILE
echo "local_umask=000" >> $CONFIG_FILE
echo "anon_umask=000" >> $CONFIG_FILE
echo "file_open_mode=0777" >> $CONFIG_FILE


#echo "allow_writeable_chroot=YES" >> $CONFIG_FILE #not required anymore

#create service to run the bash file
sudo bash -c 'echo -e "[Unit]\nDescription=vsftpd FTP server\nAfter=network.target\n\n[Service]\nType=simple\nExecStart=/usr/local/sbin/vsftpd /etc/vsftpd.conf\nExecReload=/bin/kill -HUP \$MAINPID\nExecStartPre=-/bin/mkdir -p /var/run/vsftpd/empty\n\n[Install]\nWantedBy=multi-user.target" > /lib/systemd/system/vsftpd.service'
#restart ftp server 
echo "[*] re/starting vsftpd service"
systemctl restart vsftpd

if systemctl is-active --quiet vsftpd; then
    echo "[*] vsftpd is up and running!"
else
    echo "[*] vsftpd failed to start."
    exit 1
fi

#Verification
echo "-----------------------"
echo "  -   Vulnerable vsftpd version 2.3.4 is deployed"
echo "  -   Anonymous user is enabled"
echo "  -   Anonymous upload is enabled"
echo "  -   Deploy hints in /home/ftp for anonymous user to see"