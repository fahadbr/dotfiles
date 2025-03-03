
[ -f ~/.zdotfiles/common.zsh ] && source ~/.zdotfiles/common.zsh

# wayland env
export WLR_DRM_NO_MODIFIERS=1
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1

export PATH="$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin/:${PATH}"

printcolors() {
	for c in black white red blue green cyan magenta yellow; do
		print -P "%{$reset_color%}%{$fg[$c]%}hellohellohello <- $c"
		print -P "%{$reset_color%}%{$fg_bold[$c]%}hellohellohello <- $c bold"
	done
}

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
