#!/bin/bash

if which picom &>/dev/null; then
	picom --config /etc/xdg/picom.conf
elif which xcompmgr &>/dev/null; then
	xcompmgr -c -l0 -t0 -r0 -o.00
fi

