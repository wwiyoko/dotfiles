[[ $- != *i* ]] && return

set -o vi
set -o ignoreeof
stty -ixon
shopt -s histappend
shopt -s checkwinsize
complete -F _command doas

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
PS1="[\u@\h \W]\$ "

alias bat="cat /sys/class/power_supply/BAT0/capacity"

export GPG_TTY="$(tty)"
