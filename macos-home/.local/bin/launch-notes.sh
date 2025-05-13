#!/bin/bash

export KITTY_LISTEN_ON="unix:$(find ${TMPDIR} -name 'kitty*' 2>/dev/null | head -n 1)"
kitten @launch --os-window-title=notes --type=os-window tmux attach -t notes

