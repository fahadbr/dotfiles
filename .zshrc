
[ -f ~/.dotfiles/zshcommon ] && source ~/.dotfiles/zshcommon

zstyle :omz:plugins:ssh-agent identities id_rsa github

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export HUNTER_ROOT=/data/code/.hunter

export GOPATH="/data/code/go"
#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin"
export PATH="$HOME/.dotfiles/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin/:$HOME/.ghcup/bin/:$HOME/.cabal/bin:/usr/local/sbin:/usr/local/bin:/usr/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.sn.conf ] && source ~/.sn.conf

printcolors() {
	for c in black white red blue green cyan magenta yellow; do
		print -P "%{$reset_color%}%{$fg[$c]%}hellohellohello <- $c"
		print -P "%{$reset_color%}%{$fg_bold[$c]%}hellohellohello <- $c bold"
	done
}
if [ -e /home/fahad/.nix-profile/etc/profile.d/nix.sh ]; then . /home/fahad/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -d $HOME/Android/Sdk/platform-tools/ ]; then
  export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  export PATH="$PATH:$HOME/Android/Sdk/platform-tools/"
fi
if [ -d $HOME/Android/Sdk/tools/ ]; then
  export PATH="$PATH:$HOME/Android/Sdk/tools/"
fi
[-f ~/.dotfiles/zshcommon] && source ~/.dotfiles/zshcommon
