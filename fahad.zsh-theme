ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

local return_code="%(?..%{$fg_bold[red]%}[%?]%{$reset_color%})"

PROMPT='%{$fg[cyan]%}[%~% ]$(git_custom_status)%{$reset_color%}%B$%b '
RPS1='${return_code}'
