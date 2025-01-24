#!/bin/bash
xdotool behave_screen_edge top exec bash -c 'pkill xdotool' &

xclip -o -sel c | xdotool type --clearmodifiers --file -
