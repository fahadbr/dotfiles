# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch notify
setopt shwordsplit
unsetopt autocd beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/fahad/.zshrc'

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit
prompt adam2

# End of lines added by compinstall

alias ls='ls -lrth --color=auto'
alias grep='grep --color=auto'
alias emacs='emacs -nw'
alias vim='nvim'
alias view='vim -R'
alias reapplyprofile='source ~/.zshrc'
alias editprofile='vim ~/.zshrc && reapplyprofile'

alias cdfzf='cd $(find . type d | fzf)'
alias vimfzf='vim $(find . type f | fzf)'

export TERMINAL=urxvt
export EDITOR=nvim
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.dotfiles/scripts"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
