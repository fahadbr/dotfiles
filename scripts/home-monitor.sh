display=DP1
if [[ "$1" != "" ]]; then
	display=$1
fi

xrandr --output $display --auto --scale .6x.6 --right-of eDP1
systemctl --user start powerman@ac.service
~/.fehbg

