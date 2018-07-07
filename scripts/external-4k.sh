display=DP1
if [[ "$1" != "" ]]; then
	display=$1
fi

xrandr --output $display --auto --scale .7x.7 --right-of eDP1
~/.fehbg
