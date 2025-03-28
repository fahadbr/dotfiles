alias kssh='kitty +kitten ssh'
alias heic2jpg='for f in *.HEIC(:r); do sips -s format jpeg "$f.HEIC" --out "$f.jpeg"; done'

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="${HOME}/go/bin:${PATH}"

