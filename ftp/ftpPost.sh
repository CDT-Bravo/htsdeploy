#!/bin/bash

#to be run after ftp.sh

### --- Preliminary Checks ---
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo."
  exit 1
fi

HOSTNAME=$(hostname)

case "$HOSTNAME" in
  #first 3 are normal users, last 2 are admin users
  "firetrees")
    USERS=("artificer:alchemist" "barbarian:berserker" "bard:eloquence")
    ADMINS=("CAgrupnin:Guard!an_7th" "EAlterra:Astral_Sea!!")
    ;;
  "fort-arran")
    USERS=("bloodhunter:ghostslayer" "cleric:twilight" "druid:shepherd")
    ADMINS=("LCoramar:@rchitect_@rcane" "LHollow:Necr0mancy_Thr0ne")
    ;;
  "frothwater")
    USERS=("fighter:champion" "monk:shadow" "paladin:oathbreaker")
    ADMINS=("LSeelie:H3ralds_Tom3" "NOkiro:Gu!1dm@st3r")
    ;;
  "forharn")
    USERS=("ranger:gloom-stalker" "rogue:arcane-trickster" "sorcerer:wild-magic")
    ADMINS=("VChloras:B3tray3r_Gods" "ZIlerez:1st_Knight_Avalir")
    ;;
  *)
    echo "Unknown host. Exiting."
    exit 1
    ;;
esac

#loop through users
for USER_INFO in "${USERS[@]}"; do
  USERNAME="${USER_INFO%%:*}"
  PASSWORD="${USER_INFO##*:}"

  #create user if they dont exist
  if ! id "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "User $USERNAME added and password set."
  else
    echo "User $USERNAME already exists, skipping."
  fi
done

#loop through admins
for USER_INFO in "${ADMINS[@]}"; do
  USERNAME="${USER_INFO%%:*}"
  PASSWORD="${USER_INFO##*:}"

  #create admin if they don't exist
  if ! id "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "User $USERNAME added and password set."
  else
    echo "User $USERNAME already exists, skipping."
  fi

  #give admin permissions
  adduser "$USERNAME" sudo
  echo "User $USERNAME added to sudo group."

done