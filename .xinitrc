
cd $HOME

# general services i want running with xorg
redshift -l 40.74:-73.99 -t 7500K:3500K &
lxsession &

# xorg startup config
$HOME/scripts/set-xkbdrate.sh
$HOME/scripts/disableTouchScreen.sh

xrdb -merge $HOME/.dotfiles/.Xresources
if [ "$MACHINE" == "home" ]; then
	xrdb -merge $HOME/.dotfiles/.Xresources-arch
fi

# to enable i3 logging
# exec i3 --shmlog-size=26214400

export XDG_CURRENT_DESKTOP=i3

systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && [ -n "$XDG_RUNTIME_DIR" ] && \
    [ "$XDG_RUNTIME_DIR" = "/run/user/`id -u`" ] && \
    [ -S "$XDG_RUNTIME_DIR/bus" ]; then
  # We are under systemd-logind or something remarkably similar, and
  # a user-session socket has already been set up.
  #
  # Be nice to non-libdbus, non-sd-bus implementations by using
  # that as the session bus address in the environment. The check for
  # XDG_RUNTIME_DIR = "/run/user/`id -u`" is because we know that
  # form of the address, from systemd-logind, doesn't need escaping,
  # whereas arbitrary addresses might.
  DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
  export DBUS_SESSION_BUS_ADDRESS
fi

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
fi

exec i3
