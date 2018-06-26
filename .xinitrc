
# general services i want running with xorg
redshift -t 7500K:3500K &

# xorg startup config
xset r rate 200 30
xbindkeys
xrdb -merge $HOME/.Xresources

exec i3 --shmlog-size=26214400
