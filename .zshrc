export ZSH=${ZSH:-"/home/fahad/.oh-my-zsh"}
ZSH_THEME="fahad"
DISABLE_AUTO_UPDATE="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

plugins=(
  git
  ssh-agent
  z
  zsh-interactive-cd
  zsh_reload
  zsh-autosuggestions
  zsh-syntax-highlighting
)

zstyle :omz:plugins:ssh-agent identities id_rsa github

source $ZSH/oh-my-zsh.sh

setopt appendhistory extendedglob nomatch notify incappendhistory
setopt shwordsplit
unsetopt beep sharehistory
bindkey -e

# End of lines added by compinstall

alias ls='ls -lrth --color=auto'
alias grep='grep --color=auto'
alias rrm='/bin/rm' # "real rm"
alias rm='trash-put -v'
alias tp='trash-put'
alias view='vim -R'
alias reapplyprofile='source ~/.zshrc'
alias editprofile='vim ~/.zshrc && reapplyprofile'
alias editssh='vim ~/.ssh/config'
alias sdu='systemctl --user'
alias sd='systemctl'
alias udc='udisksctl'
alias pbcopy='xclip -i -sel clip'
alias pbpaste='xclip -o -sel clip'
alias cpr='rsync -ah --info=progress2'
alias t="todo.sh"
alias ta="todo.sh add"
alias open="xdg-open"

export TODO_DIR="/data/syncthing/todo"
#export TERMINAL=urxvt
export EDITOR=nvim
export LESS="-RF"
export GOPATH="/data/code/go"
#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin"
export PATH="$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin/:$HOME/.ghcup/bin/:$HOME/.cabal/bin:/usr/local/sbin:/usr/local/bin:/usr/bin"
export MACHINE=${MACHINE:-"home"}
export HUNTER_ROOT=/data/code/.hunter
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.sn.conf ] && source ~/.sn.conf

printcolors() {
	for c in black white red blue green cyan magenta yellow; do
		print -P "%{$reset_color%}%{$fg[$c]%}hellohellohello <- $c"
		print -P "%{$reset_color%}%{$fg_bold[$c]%}hellohellohello <- $c bold"
	done
}
if [ -e /home/fahad/.nix-profile/etc/profile.d/nix.sh ]; then . /home/fahad/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -d $HOME/Android/Sdk/platform-tools/ ]; then
  export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  export PATH="$PATH:$HOME/Android/Sdk/platform-tools/"
fi
if [ -d $HOME/Android/Sdk/tools/ ]; then
  export PATH="$PATH:$HOME/Android/Sdk/tools/"
fi
