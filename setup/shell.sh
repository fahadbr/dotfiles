#!/bin/bash

set -ex

# clone and install fzf
if [[ ! -d $HOME/.fzf ]]; then
	echo "installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

if [[ ! -f $HOME/.config/nnn/plugins/preview-tui ]]; then
  nnn_plugins_dir=$HOME/.config/nnn/plugins
  mkdir -vp $nnn_plugins_dir
  pushd $nnn_plugins_dir
  curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
  popd
fi



