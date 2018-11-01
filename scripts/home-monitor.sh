display=DP1
if [[ "$1" != "" ]]; then
	display=$1
fi

if uname -a | grep ARCH >/dev/null; then
	xrandr --output $display --auto --scale .6x.6 --right-of eDP1
else
	xrandr --output $display --mode 1920x1080 --right-of eDP1
fi

systemctl --user start powerman@ac.service
~/.fehbg

