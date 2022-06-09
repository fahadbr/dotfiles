#!/bin/bash

if [[ ! -f $HOME/.local/bin/kmonad ]]; then
	mkdir -p $HOME/code
	git clone https://github.com/kmonad/kmonad.git $HOME/code/kmonad

	cd $HOME/code/kmonad
	stack install
fi

if [[ ! -f /usr/lib/systemd/system/kmonad.service ]]; then
	sudo tee /usr/lib/systemd/system/kmonad.service <<EOF
[Unit]
Description=kmonad keyboard config

[Service]
Restart=always
RestartSec=3
ExecStart=$HOME/.local/bin/kmonad $HOME/.dotfiles/kmonad/config.kbd
Nice=-20

[Install]
WantedBy=default.target
EOF
fi
