
cd $HOME

# general services i want running with xorg
redshift -l 40.74:-73.99 -t 7500K:3500K &

# xorg startup config
$HOME/scripts/set-xkbdrate.sh
$HOME/scripts/disableTouchScreen.sh

xrdb -merge $HOME/.Xresources

# to enable i3 logging
# exec i3 --shmlog-size=26214400

export XDG_CURRENT_DESKTOP=i3
exec dbus-launch --exit-with-session i3
