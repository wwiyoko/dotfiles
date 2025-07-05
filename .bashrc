[[ $- == *i* ]] || return

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

set -o ignoreeof
shopt -s histappend
shopt -s checkwinsize
stty -ixon

. /usr/share/bash-completion/bash_completion

export GPG_TTY="$(tty)"
