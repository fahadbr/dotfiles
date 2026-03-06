# checks and executions which should be done on all systems
# but only after the final path has been evaluated

if which zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

if which nvim &>/dev/null; then
  export EDITOR=nvim
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
