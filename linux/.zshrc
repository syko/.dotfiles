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


# WSL: never launch the Linux GUI browser; print URLs instead (see ~/.local/bin/www-browser)
export BROWSER=www-browser
