#!/bin/bash

xset r rate 200 45
id=$(xinput list | grep 'Logitech K811 Keyboard' | sed -En 's/.*id=([0-9]+).*/\1/p')
setxkbmap -device $id -option 'altwin:swap_lalt_lwin'
