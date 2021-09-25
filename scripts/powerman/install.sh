#!/bin/bash

#if [[ "$(whoami)" != "root" ]]; then
	#echo "must run with sudo!"
	#exit 1
#fi

# check dependencies
which xprintidle &>/dev/null || ( echo "xprintidle not installed" && exit 1 )
which pacmd &>/dev/null || ( echo "pacmd (pulseaudio) not installed" && exit 1 )
cwd=$(pwd)

for f in powerman.sh powerman@.service xpowerman@.service; do
	[[ ! -f ./$f ]] && echo "$f not in current working directory" && exit 1
done

homedir=/home/$(logname)

servicefile=xpowerman@.service
if [[ $WAYLAND_DISPLAY ]]; then
	servicefile=powerman@.service
fi

ln -vsfT $cwd/watch-sleep.sh $homedir/.local/bin/watch-sleep.sh
ln -vsfT $cwd/sleep.target $homedir/.config/systemd/user/sleep.target
ln -vsfT $cwd/watch-sleep.service $homedir/.config/systemd/user/watch-sleep.service
ln -vsfT $cwd/$servicefile $homedir/.config/systemd/user/powerman@.service
ln -vsfT $cwd/lock.service $homedir/.config/systemd/user/lock.service

systemctl --user daemon-reload
systemctl --user enable --now watch-sleep.service
systemctl --user enable lock.service
#ln -vsfT $cwd/resume-lock@.service /etc/systemd/system/resume-lock@.service
#systemctl enable resume-lock@$(logname).service

## Not using udev rules anymore since they are not reliable
#
# ln -v -s -f $cwd/99-powerman.rules /etc/udev/rules.d/99-powerman.rules
# echo "reloading udev rules"
# udevadm control --reload-rules && udevadm trigger
