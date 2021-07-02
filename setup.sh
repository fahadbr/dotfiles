#!/bin/bash

set -ex
# download oh my zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
	echo "Downloading oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# copy theme

if [[ ! -f $HOME/.oh-my-zsh/custom/themes/fahad.zsh-theme ]]; then
	echo "Linking prompt theme"
	ln -sfT $HOME/.dotfiles/fahad.zsh-theme $HOME/.oh-my-zsh/custom/themes/
fi

pushd $HOME/.oh-my-zsh/custom/plugins/

# clone zsh autosuggestions
if [[ ! -d ./zsh-autosuggestions ]]; then
	echo "installing zsh-autosuggestions"
	git clone git@github.com:zsh-users/zsh-autosuggestions.git
fi

# clone zsh highlighting
if [[ ! -d ./zsh-syntax-highlighting ]]; then
	echo "installing zsh-syntax-highlighting"
	git clone git@github.com:zsh-users/zsh-syntax-highlighting.git
fi

popd


# clone and install fzf
if [[ ! -d $HOME/.fzf ]]; then
	echo "installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi

sourceline="[-f ~/.dotfiles/zshcommon] && source ~/.dotfiles/zshcommon"
if ! grep -q "$sourceline" $HOME/.zshrc; then
	echo "adding common aliases to .zshrc"
	echo "$sourceline" >> $HOME/.zshrc
fi
