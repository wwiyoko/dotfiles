[[ $- == *i* ]] || return

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

set -o ignoreeof
shopt -s histappend
shopt -s checkwinsize
stty -ixon

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

export GPG_TTY="$(tty)"
