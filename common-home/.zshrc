autoload_dir="${HOME}/.zshrc.d"
if [[ -d "${autoload_dir}" ]]; then
  for f in "${autoload_dir}"/*.zsh; do
    [[ -r "$f" ]] && source "$f"
  done
fi

# source ~/.lcldevrc
