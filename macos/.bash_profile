#defaults write NSGlobalDomain KeyRepeat -int 1
#defaults write -g InitialKeyRepeat -int 10

export PATH="$PATH:/$HOME/bin"

alias ls='ls -G'
alias grep='grep -G'
alias fgrep='fgrep -G'
alias egrep='egrep -G'
alias ll='ls -alF'
alias la='ls -lah'
alias l='ls -CF'

alias s='git status -sb'
alias co='git-fuzzy-co'
alias m='git co master'
alias d='git diff --color --color-words'
alias dlin='git diff --color'
alias ds='git diff --color --color-words --staged'
alias dslin='git diff --color --staged'
alias c='git checkout'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias g='git co'
alias gc='git commit'
alias gcp='git commit -p'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gcamend='git commit --amend'
alias glmb='gl `git merge-base master HEAD`..'
alias ghreset='git reset --hard HEAD'
alias gundocommit='git reset --mixed HEAD~1'
alias ghresetprev='git reset --hard HEAD~1'
alias gpl='git pull'
alias gps='git push'
alias gall='git add -A'
alias gcontinue='git rebase --continue'
alias gabort='git rebase --abort'
alias grim="git rebase -i master"
alias gprim="git co master && gpl && git co - && git rebase -i master"
alias grm="git rebase master"
alias gprm="git co master && gpl && git co - && git rebase master"
alias giddy="git"
alias get="bash -c 'git up'"
alias gstash="git stash"
alias gspop="git stash pop"
alias y="yarn start"
alias h="yarn run hyperdev"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#PATH=$PATH:/home/syko/apps/mongodb-linux-x86_64-2.6.5/bin

source ~/.nvm/nvm.sh

# To enable opening terminals and running commands after bashrc
eval "$BASH_POST_RC"

eval $(thefuck --alias)
alias fuckyou='sudo !!'

export PATH=./node_modules/.bin:$PATH

export SASS_LIBSASS_PATH=$HOME/apps/libsass
export PHANTOMJS_BIN=$HOME/apps/phantomjs-2.1.1-macosx/bin/phantomjs

export PATH=~/.rbenv/shims:$PATH

export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
# Set Titlebar and Prompt
PS1='\[${CYAN}\]\u\[${NORMAL}\]@\[${YELLOW}\]`echo ${PWD} | sed -E "s/.*\\///"`\[${NORMAL}\]:\[${GREEN}\]`git rev-parse --abbrev-ref HEAD 2> /dev/null`\[${WHITE}\] \$ \[${NORMAL}\]'
