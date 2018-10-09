
cd $HOME

# general services i want running with xorg
redshift -l 40.74:-73.99 -t 7500K:3500K &

# xorg startup config
$HOME/scripts/set-xkbdrate.sh
$HOME/scripts/disableTouchScreen.sh

xrdb -merge $HOME/.dotfiles/.Xresources
if uname -a | grep ARCH >/dev/null; then
	xrdb -merge $HOME/.dotfiles/.Xresources-arch
fi

# to enable i3 logging
# exec i3 --shmlog-size=26214400

export XDG_CURRENT_DESKTOP=i3

systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
fi

if uname -a | grep ARCH >/dev/null; then
	exec i3
else
	exec dbus-launch --exit-with-session i3
fi
