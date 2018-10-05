display=DP1
if [[ "$1" != "" ]]; then
	display=$1
fi

xrandr --output $display --auto --scale .6x.6 --right-of eDP1
xfce4-power-manager --restart
~/.fehbg

