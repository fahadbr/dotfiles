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
	GITEMAIL=$(git config --global --get user.email)
	greeterText="$(git config --global --get user.name)
$GITEMAIL"

	if which betterlockscreen 2>&1; then
		betterlockscreen --lock --text "$GITEMAIL" -- $ignoreempty --time-str="%I:%M %p"
	else
		i3lock -n \
			$ignoreempty  \
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
		--color=00000088						 \
		--blur 5                     \
		--screen 1                   \
		--clock                      \
		--indicator                  \
		--time-str="%I:%M %p"        \
		--date-str="%a, %b %d %Y"    \
		--greeter-pos="300:50"			 \
		--greeter-color=$TEXT        \
		--greeter-text="$greeterText"
	fi
fi

$HOME/.dotfiles/scripts/set-xkbdrate.sh
