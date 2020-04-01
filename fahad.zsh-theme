ZSH_THEME_GIT_PROMPT_PREFIX="-%{$fg[cyan]%}[%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

goenv() {
  local e=$(echo $GOPATH | grep -Eo "go2|go3")
  if [[ $e ]]; then
    echo "-[%{$fg[green]%}$e%{$fg[cyan]%}]"
  fi
}

sshhostname() {
  if [[ $SSH_CONNECTION ]]; then
    echo "%{$fg[cyan]%}[$HOST]-"
  fi
}

# %{$fg[red]%}
local return_code="%(?..%{$fg[red]%}[%?])"



PROMPT='%{$reset_color%}$(sshhostname)%{$fg[cyan]%}[%~% ]$(goenv)$(git_custom_status)%{$reset_color%}
${return_code}%B$%b '
