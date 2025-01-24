[ -f ~/.zshcommon ] && source ~/.zshcommon

alias kssh='kitty +kitten ssh'
alias heic2jpg='for f in *.HEIC(:r); do sips -s format jpeg "$f.HEIC" --out "$f.jpeg"; done'

eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR='nvim'
export PATH="${HOME}/go/bin:${PATH}"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
