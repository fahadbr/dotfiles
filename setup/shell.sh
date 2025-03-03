#!/bin/bash

set -ex

# clone and install fzf
if [[ ! -d $HOME/.fzf ]]; then
	echo "installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	yes | ~/.fzf/install
fi

tmux_plugins_dir="${HOME}/.tmux/plugins"
if [[ ! -d ${tmux_plugins_dir} ]]; then
	echo "installing tpm (tmux plugin manager)"
	git clone https://github.com/tmux-plugins/tpm ${tmux_plugins_dir}/tpm && \
		${tmux_plugins_dir}/tpm/bin/install_plugins
fi



