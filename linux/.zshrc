eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

[[ -r ~/.zshrc_syko ]] && . ~/.zshrc_syko
[[ -r ~/.zshrc_device ]] && . ~/.zshrc_device

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

HISTSIZE=10000
SAVEHIST=10000
HISTCONTROL=ignoreboth

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


bindkey '^ ' autosuggest-accept

# WSL: never launch the Linux GUI browser; print URLs instead (see ~/.local/bin/www-browser)
export BROWSER=www-browser

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
