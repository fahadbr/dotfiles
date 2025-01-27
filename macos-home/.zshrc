[ -f ~/.common.zsh ] && source ~/.common.zsh

alias kssh='kitty +kitten ssh'
alias heic2jpg='for f in *.HEIC(:r); do sips -s format jpeg "$f.HEIC" --out "$f.jpeg"; done'

eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR='nvim'
export PATH="${HOME}/go/bin:${PATH}"

post_path_evals
