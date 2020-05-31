
reset_keyboard() {
	keyboard=$1
	id=$(xinput list | grep "$1" | grep 'keyboard' | grep -v 'Control' | sort | head -n1 | sed -En 's/.*id=([0-9]+).*/\1/p')
	setxkbmap -device $id -option ''
}

xset r rate 200 45
setxkbmap -option 'caps:swapescape'
reset_keyboard "Keebio \"Fahad's Iris Keyboard\""
reset_keyboard "OLKB \"Fahad's Planck Keyboard\""
