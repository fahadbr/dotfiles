#!/bin/bash

set -ex

mkdir -p ${HOME}/.zshrc.d

stow -R -t ${HOME} common-home

if [[ "$(uname)" == "Darwin" ]]; then
    stow -R -t ${HOME} macos-home
else
    stow -R -t ${HOME} linux-home
fi

# clone and install fzf
if [[ ! -d $HOME/.fzf ]]; then
	echo "installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --completion --key-bindings --no-update-rc --no-bash
fi


