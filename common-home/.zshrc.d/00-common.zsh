# vim:foldmethod=marker

export ZDOTFILES=${HOME}/.zdotfiles
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
# {{{ Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# {{{ oh-my-zsh variables and config

if [[ -f ~/.ssh/id_rsa ]]; then
  zstyle :omz:plugins:ssh-agent identities id_rsa id_ed25519
fi

# }}}

# {{{ antidote install and load
ANTIDOTE_HOME=${ZDOTFILES:-$HOME}/.antidote
if [[ ! -d ${ANTIDOTE_HOME} ]]; then
  echo "installing antidote zsh plugin manager"
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ANTIDOTE_HOME}
fi

# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZDOTFILES:-$HOME}/zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=(${ANTIDOTE_HOME}/functions $fpath)
autoload -Uz antidote
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

# }}}

# {{{ zsh builtin options
setopt extendedglob
setopt nomatch
setopt notify
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt incappendhistory
setopt shwordsplit
setopt completeinword
unsetopt beep
unsetopt sharehistory
bindkey -e
bindkey '^z' push-input # save the current line, clear it, and then bring it back in the next prompt

case $TERM in
    xterm*)
	precmd () {
	  #15 char left truncated PWD
	  print -Pn "\e]0;%15<..<%~%<<\a"
	}
	preexec () {
	  # cmd name only, or if this is sudo or ssh, the next cmd
	  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
	  print -Pn "\e]0;$CMD\a"
	}
        ;;
esac

# }}}

# {{{ directories
setopt auto_cd              # if the commands name is not a command but a directory, change to the directory
setopt auto_pushd           # Push the current directory visited on the stack.
setopt pushd_ignore_dups    # Do not store duplicates in the stack.
setopt pushd_silent         # Do not print the directory stack after pushd or popd.
setopt pushd_minus          # Exchanges the meanings of `+' and `-' when used with a number to specify a directory in the stack.

for index ({1..9}) alias "$index"="cd -${index}"; unset index
alias d='dirs -v'
alias -- -='cd -'
alias -g ...='cd ../..'
alias -g ....='cd ../../..'
alias -g .....='cd ../../..'
alias -g ......='cd ../../../..'

alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
# }}}

export EDITOR=${EDITOR:=vim}
export LESS="-RF"
export MACHINE=${MACHINE:-"home"}
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export HISTSIZE=130000
export SAVEHIST=130001
export PATH="$HOME/.local/bin:$PATH"
export LC_COLLATE="C"
export PAGER="less $LESS"

# allows previewing long shell history lines by pressing '?' in fzf
export FZF_CTRL_R_OPTS="--height 50% --preview 'echo {2..}' --preview-window 'up,60%,hidden,wrap' --bind '?:toggle-preview'"
export FZF_CTRL_T_COMMAND="command find -L . -mindepth 1 \\( -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"
 export FZF_ALT_C_COMMAND="command find -L . -mindepth 1 \\( -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
          -o -type d -print 2> /dev/null | cut -b3-"

alias ls='ls -lrth --color=auto'
alias reapplyprofile='exec zsh'
alias editprofile="${EDITOR} ${HOME}/.zshrc && exec zsh"
alias editzshcommon="${EDITOR} ${HOME}/.zdotfiles/common.zsh && exec zsh"
alias editssh="${EDITOR} ${HOME}/.ssh/config"
alias view="${EDITOR} -R"
alias lg='lazygit'
alias printpath='echo $PATH | sed "s/:/\n/g"'
alias grep='grep --color=auto'
alias tma='tmux attach -t $(tmux list-sessions | cut -d ':' -f 1 | fzf)'
alias ghf='gh repo fork --clone'
alias nvimsl='nvim -c "SessionLoad"'

bin2dec() {
  echo $((2#$1))
}

# {{{ yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function n() {
  echo 'use "y" for yazi instead of nnn'
}
# }}}

#source ${ZDOTFILES}/vi-emulation.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ${ZDOTFILES}/p10k.zsh ] && source ${ZDOTFILES}/p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
