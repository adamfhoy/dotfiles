#!/bin/bash/

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Read /etc/bashrc if present
if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

# ------------------------------------------------------------
# Prompt format
# ------------------------------------------------------------

PS1="[\u@\h\[\033[33m\]\$(git branch 2>/dev/null | grep '\*' | sed -e 's/../ /')\[\033[0m\] \W]\\$ "

# ------------------------------------------------------------
# History settings
# ------------------------------------------------------------

HISTFILESIZE=1000000
HISTSIZE=10000

# 
export HISTIGNORE="cd:ls:clear:exit:bg:fg:&"
export HISTCONTROL=ignoredups

# ------------------------------------------------------------
# PATH settings
# ------------------------------------------------------------

# export PATH=/utils/bin:$PATH
export DOTFILES="/home/adamfhoy/dotfiles/dotfiles"

# ------------------------------------------------------------
# Aliases
# ------------------------------------------------------------

alias xterm='xterm -geometry 100x35'
alias ex=exit
alias qqq="gnome-terminal --geometry=100x70"
alias notes="gnome-terminal --working-directory=/home/hoy/notes --geometry=100x35+2200+100"
alias tcode="gnome-terminal --working-directory=/home/hoy/testcode --geometry=100x70+900+0"
alias larger='printf "\e[8;70;100;t"'
alias smaller='printf "\e[8;35;100;t"'
# alias larger="resize -s 70 100"
# alias smaller="resize -s 35 100"

setxkbmap -option ctrl:nocaps

