export ZSH="/home/fahad/.oh-my-zsh"
ZSH_THEME="fahad"
DISABLE_AUTO_UPDATE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

plugins=(
  git, z
)

source $ZSH/oh-my-zsh.sh

setopt appendhistory extendedglob nomatch notify
setopt shwordsplit
unsetopt beep sharehistory
bindkey -e

# End of lines added by compinstall

alias ls='ls -lrth --color=auto'
alias grep='grep --color=auto'
alias emacs='emacs -nw'
alias vim='nvim'
alias view='vim -R'
alias reapplyprofile='source ~/.zshrc'
alias editprofile='vim ~/.zshrc && reapplyprofile'
alias sdu='systemctl --user'
alias sd='systemctl'
alias udc='udisksctl'
alias pbcopy='xclip -i -sel clip'
alias pbpaste='xclip -o -sel clip'
alias cpr='rsync -ah --info=progress2'

alias cdfzf='cd $(find . type d | fzf)'
alias vimfzf='vim $(find . type f | fzf)'

export TERMINAL=urxvt
export EDITOR=nvim
export LESS="-RF"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.dotfiles/scripts"
export MACHINE=home


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function printcolors {
	for c in black white red blue green cyan magenta yellow; do
		print -P "%{$reset_color%}%{$fg[$c]%}hellohellohello <- $c"
		print -P "%{$reset_color%}%{$fg_bold[$c]%}hellohellohello <- $c bold"
	done
}
