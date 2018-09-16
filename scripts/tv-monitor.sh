display=DP1
if [[ "$1" != "" ]]; then
	display=$1
fi

xrandr --output $display --auto --right-of eDP1
xfce4-power-manager --restart
~/.fehbg

pactl set-card-profile 0 output:hdmi-stereo-extra1

