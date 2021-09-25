#!/bin/bash
# taken from https://medium.com/@aiguofer/systemd-sleep-target-for-user-level-10eb003b3bfd

dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member=PrepareForSleep" | while read x; do
    case "$x" in
        *"boolean false"*) systemctl --user --no-block stop sleep.target;;
        *"boolean true"*) systemctl --user --no-block start sleep.target;;
    esac
done
