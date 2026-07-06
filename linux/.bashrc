[[ -r ~/.bashrc_syko ]] && . ~/.bashrc_syko
[[ -r ~/.bashrc_device ]] && . ~/.bashrc_device

HISTSIZE=10000
SAVEHIST=10000
HISTCONTROL=ignoreboth

. "$HOME/.atuin/bin/env"
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"


# Warp registers bare `precmd`/`preexec` hook names but doesn't define them.
# Without these no-ops, every prompt's failed lookup falls through to Ubuntu's
# command_not_found_handle (the slow apt-DB scanner), adding ~0.5-0.8s/command.
precmd()  { :; }
preexec() { :; }
source '/home/linuxbrew/.linuxbrew/opt/autoenv/activate.sh'

# Restore bare `cd` -> $HOME while keeping autoenv's .env sourcing
cd() {
	if [ "$#" -eq 0 ]; then
		autoenv_cd "$HOME"
	else
		autoenv_cd "$@"
	fi
}
