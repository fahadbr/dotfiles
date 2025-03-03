#!/bin/bash

set -ex

# clone and install fzf
if [[ ! -d $HOME/.fzf ]]; then
	echo "installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	yes | ~/.fzf/install
fi




