#!/bin/bash

set -ex
# download oh my zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
	echo "Downloading oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

pushd $HOME/.oh-my-zsh/custom/plugins/

# clone zsh autosuggestions
if [[ ! -d ./zsh-autosuggestions ]]; then
	echo "installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git
fi

# clone zsh highlighting
if [[ ! -d ./zsh-syntax-highlighting ]]; then
	echo "installing zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
fi

popd


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



