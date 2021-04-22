#!/bin/bash
# generates a simple lock screen image with just the username and email
# based on the git global config
# imagemagick is required for this
# must be run separately from install.sh


res=${RESOLUTION:='1920x1080'}

name=$(git config --global --get user.name)
email=$(git config --global --get user.email)
font=$(fc-list | grep UbuntuMono-R.ttf | cut -d ':' -f 1)

convert -size $res \
	-background '#09112D' \
	-font $font \
	-pointsize 50 \
	-fill '#52F6FF' \
	-gravity NorthWest caption:"\n  $name\n  $email" \
	-flatten ~/.config/lockscreen.png
