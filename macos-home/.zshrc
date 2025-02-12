[ -f ~/.zdotfiles/common.zsh ] && source ~/.zdotfiles/common.zsh

alias kssh='kitty +kitten ssh'
alias heic2jpg='for f in *.HEIC(:r); do sips -s format jpeg "$f.HEIC" --out "$f.jpeg"; done'

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="${HOME}/go/bin:${PATH}"

post_path_evals

source ~/.lcldevrc

export https_proxy="http://127.0.0.1:8888"
export HTTPS_PROXY="$https_proxy"
export http_proxy="$https_proxy"
export HTTP_PROXY="$https_proxy"
