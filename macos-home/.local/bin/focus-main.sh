#!/bin/bash

export KITTY_LISTEN_ON="unix:$(find ${TMPDIR} -name 'kitty*' 2>/dev/null | head -n 1)"
kitten @focus-window --match 'title:K4W4WJNX07 not title:notes'


