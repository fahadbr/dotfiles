xset r rate 200 45
setxkbmap -option 'caps:swapescape'
id=$(xinput list | grep 'Keebio Iris Keyboard' | grep 'keyboard' | grep -v 'Control' | sed -En 's/.*id=([0-9]+).*/\1/p')
setxkbmap -device $id -option ''
