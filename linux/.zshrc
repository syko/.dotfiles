[[ -r ~/.zshrc_syko ]] && . ~/.zshrc_syko
[[ -r ~/.zshrc_device ]] && . ~/.zshrc_device

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

HISTSIZE=10000
SAVEHIST=10000
HISTCONTROL=ignoreboth

# ---- plugins ----

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


bindkey '^ ' autosuggest-accept

source '/home/linuxbrew/.linuxbrew/opt/autoenv/activate.sh'

# Restore bare `cd` -> $HOME while keeping autoenv's .env sourcing
cd() {
	if [ "$#" -eq 0 ]; then
		autoenv_cd "$HOME"
	else
		autoenv_cd "$@"
	fi
}
