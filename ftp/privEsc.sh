#!/bin/bash

#to be run after ftpPost.sh
#creates basic sudo misconfigs that lead to root shells

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

HOSTNAME=$(hostname)

case $HOSTNAME in
    :'NANO gives the user sudo privs for nano. Can escape nano and get a root shell this way
    FIND gives the user sudo privs for find. Can be escaped for a root shell
    SSH gives the user sudo privs for ssh. Can be escaped for a root shell
    '
    "firetrees")
        NANO="artificer"
        FIND="barbarian"
        SSH="bard"
        ;;
    "fort-arran")
        NANO="bloodhunter"
        FIND="cleric"
        SSH="druid"
        ;;
    "frothwater")
        NANO="fighter"
        FIND="monk"
        SSH="paladin"
        ;;
    "forharn")
        NANO="ranger"
        FIND="rogue"
        SSH="sorcerer"
        ;;
    *)
        echo "Unknown Host."
        exit 1
        ;;
esac

echo "$NANO ALL=(ALL) NOPASSWD: /usr/bin/nano" | sudo tee /etc/sudoers.d/$NANO-nano
echo "$FIND ALL=(ALL) NOPASSWD: /usr/bin/find" | sudo tee /etc/sudoers.d/$FIND-nano
echo "$SSH ALL=(ALL) NOPASSWD: /usr/bin/ssh" | sudo tee /etc/sudoers.d/$SSH-nano

