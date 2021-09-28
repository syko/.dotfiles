export PATH="$PATH:/$HOME/bin"

alias ls='ls -G --color'
alias grep='grep -G'
alias fgrep='fgrep -G'
alias egrep='egrep -G'
alias ll='ls -alF'
alias la='ls -lah --color'
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
alias gpst='git push --tags'
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

source ~/.nvm/nvm.sh

# To enable opening terminals and running commands after bashrc
eval "$BASH_POST_RC"

alias fuckyou='sudo !!'

export PATH=./node_modules/.bin:$PATH

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

export LS_COLORS="di=01;31;36:ow=01;31;36:fi=01;32:ln=01;33:mi=01;31:ex=01;32"

# Start ssh-agent automatically https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
