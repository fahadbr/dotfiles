#!/bin/bash

if [[ "$(whoami)" != "root" ]]; then
	echo "must run with sudo!"
	exit 1
fi

# check dependencies
which xprintidle &>/dev/null || ( echo "xprintidle not installed" && exit 1 )
which pacmd &>/dev/null || ( echo "pacmd (pulseaudio) not installed" && exit 1 )
cwd=$(pwd)

for f in powerman.sh powerman@.service powerman.rules; do
	[[ ! -f ./$f ]] && echo "$f not in current working directory" && exit 1
done

homedir=/home/$(logname)

ln -v -s -f $cwd/powerman@.service $homedir/.config/systemd/user/powerman@.service
ln -v -s -f $cwd/powerman.sh /usr/local/bin/powerman.sh
ln -v -s -f $cwd/powerman.rules /etc/udev/rules.d/powerman.rules

echo "reloading udev rules"
udevadm control --reload-rules && udevadm trigger
