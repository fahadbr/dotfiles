#!/bin/bash
# generates a simple lock screen image with just the username and email
# based on the git global config
# imagemagick is required for this
# must be run separately from install.sh

name=$(git config --global --get user.name)
email=$(git config --global --get user.email)

convert -size 1920x1080 \
	-background '#222222' \
	-font /usr/share/fonts/TTF/UbuntuMono-R.ttf \
	-pointsize 25 \
	-fill '#00FF00' \
	-gravity NorthWest caption:"\n  $name\n  $email" \
	-flatten ~/.config/lockscreen.png
