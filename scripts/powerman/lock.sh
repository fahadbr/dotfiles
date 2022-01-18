#!/bin/bash

ignoreempty=""
if [[ "$1" == "--ignore-empty-password" ]]; then
	ignoreempty="--ignore-empty-password"
fi

if ! i3lock --version 2>&1 | grep -q 'Raymond Li'; then
	i3lock -n \
		$ignoreempty  \
		--show-failed-attempts  \
		--pointer win \
		--tiling \
		--image ~/.config/lockscreen.png
else
	BLANK='#00000000'
	CLEAR='#ffffff22'
	DEFAULT='#eeeeeecc'
	TEXT='#ddddddee'
	WRONG='#880000bb'
	VERIFYING='#5500bbbb'

	i3lock \
	--insidever-color=$CLEAR     \
	--ringver-color=$VERIFYING   \
	\
	--insidewrong-color=$CLEAR   \
	--ringwrong-color=$WRONG     \
	\
	--inside-color=$BLANK        \
	--ring-color=$DEFAULT        \
	--line-color=$BLANK          \
	--separator-color=$DEFAULT   \
	\
	--verif-color=$TEXT          \
	--wrong-color=$TEXT          \
	--time-color=$TEXT           \
	--date-color=$TEXT           \
	--layout-color=$TEXT         \
	--keyhl-color=$WRONG         \
	--bshl-color=$WRONG          \
	\
	--screen 1                   \
	--blur 7                     \
	--clock                      \
	--indicator                  \
	--time-str="%H:%M:%S"        \
	--date-str="%A, %m %Y"       \
	--greeter-text="fahadriaz@fb.com" \
	--greeter-color=$TEXT        \
	--greeter-pos="200:100"

fi

$HOME/.dotfiles/scripts/set-xkbdrate.sh
