
[ -f ~/.zdotfiles/common.zsh ] && source ~/.zdotfiles/common.zsh

zstyle :omz:plugins:ssh-agent identities id_rsa github

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export HUNTER_ROOT=/data/code/.hunter

# wayland env
export WLR_DRM_NO_MODIFIERS=1
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1

export GOPATH="/data/code/go"
#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin"
export PATH="$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin/:/usr/local/sbin:/usr/local/bin:/usr/bin"

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

export MOZ_USE_XINPUT2=1
alias grep='grep --color=auto'
alias udc='udisksctl'
alias open="xdg-open"
alias cpr='rsync -ah --info=progress2'
alias cp='cp --backup=numbered'
alias ln='ln --backup=numbered'
alias mv='mv -f --backup=numbered'
alias rrm='/bin/rm' # "real rm"
alias sdu='systemctl --user'
alias sd='systemctl'
alias susd='sudo systemctl'
if [[ $WAYLAND_DISPLAY ]]; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
else
  alias pbcopy='xclip -i -sel clip'
  alias pbpaste='xclip -o -sel clip'
fi

if which trash-put &>/dev/null; then
  alias rm='trash-put -v'
  alias tp='trash-put'
  export NNN_TRASH=1
fi

post_path_evals
