
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LANG=en_US.UTF-8

export ZSH=/Users/fahad/.oh-my-zsh

ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"

plugins=(git docker k8s)

source $ZSH/oh-my-zsh.sh

# User configuration


export DEVDIR=$HOME/dev
export DEVBIN=$HOME/devbin
export GOROOT=/usr/local/Cellar/go/1.10/libexec
export GOPATH=$DEVDIR/go
#export LD_LIBRARY_PATH=/Users/fahad/dev/axcore/ext/secp256k1/.libs:/Users/fahad/dev/axcore/ext/evmjit/build/libevmjit
export NEWLINE=$'\n'
#export PROMPT='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)${NEWLINE}${ret_status} %{$reset_color%}'
export PROMPT='%{$fg[cyan]%}%~%{$reset_color%} $(k8s_context_info)$(git_prompt_info)${NEWLINE}${ret_status} %{$reset_color%}'
#export PROMPT='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)${NEWLINE}> '
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$GOPATH/bin:$DEVBIN"
export EDITOR="nvim"
export AXCORE="$GOPATH/src/axoni.com/axcore"
export AXOPS_INVENTORY=$DEVDIR/axops-inventories/infinity
export KOPS_STATE_STORE=s3://axoni-k8s-state-store
export REG_REGISTRY=docker.axoni.com

alias ls="ls -lrthG"
alias vim='nvim'
alias view='vim -R'
alias grep="grep --color=auto"
alias cgrep="grep --exclude-dir={.git,build,vendor}"
alias reapplyprofile="source ~/.zshrc"
alias editprofile="vim ~/.zshrc && reapplyprofile"
alias editrundef="vim ~/.axops/clusters/fahad-docker-compose.yml"
alias editssh="vim ~/.ssh/config"
alias todo="vim ~/Documents/todo.md"
alias playground="code $GOPATH/src/axoni.com/playground"
alias btstrplocal="bootstrapper -bootstrap /Users/fahad/dev/go/src/axoni.com/axinfra/infinity/bootstrap.json -axapi-url localhost:21003"

alias cddev="cd $DEVDIR" 
alias cdscripts="cd $DEVDIR/local/scripts"
alias cddevbin="cd $DEVBIN"
alias cdaxcore="cd $AXCORE"
alias cdloadgen="cd $GOPATH/src/axoni.com/loadgen"
alias cdaxops="cd $GOPATH/src/axoni.com/axops"
alias cdaxbuilder="cd $GOPATH/src/axoni.com/axbuilder"
alias cdnotes="cd $HOME/Documents/notes"


function cdlogs { cd ~/.axops/logs/$(cat $DEVBIN/config/network) }

alias psqllocal="psql -h localhost postgres postgres"

function timestamp {
  date '+%Y%m%d%H%M%s'
}

function readlogs {
  docker logs $1 2>&1 | less -S
}

function taillogs {
  docker logs -f --tail 500 $1
}

function dockerhostip {
  docker exec $1 /sbin/ip route | awk '/default/ { print $3 }'
}

function newinterview {
	vim ~/Documents/interviews/$1
}

function sshStreamV2 {
	ssh -o ProxyCommand="ssh -W $1:22 admin@bastion-streamv2" admin@$1 -i ~/.ssh/v2test
}

function kops-set-creds {
	case $1 in
		"ax")
			export AWS_PROFILE=default
			export KOPS_STATE_STORE="s3://axoni-k8s-state-store"
			;;
		"qa")
			export AWS_PROFILE=qa
			export KOPS_STATE_STORE="s3://axqa-kops-state-store"
			;;
		"nex")
			export AWS_PROFILE=nex
			export KOPS_STATE_STORE="s3://ax-nex-k8s"
			;;
		*)
			"no profile found for $1"
			;;
	esac
	echo "AWS_PROFILE=$AWS_PROFILE"
	echo "KOPS_STATE_STORE=$KOPS_STATE_STORE"
}

#zsh specfic
unsetopt share_history
setopt sh_word_split

# precmd() {
# 	echo -ne "\033];${PWD##*/}\007"
# }

