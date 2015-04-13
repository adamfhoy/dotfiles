#!/bin/bash/

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Read /etc/bashrc if present
if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

PS1="[\h\[\033[33m\]\$(git branch 2>/dev/null | grep '\*' | sed -e 's/../ /')\[\033[0m\] \W]\\$ "

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
export PATH=$PATH:/usr/sbin
export PATH=$PATH:/utils/bin
export PATH=$PATH:/software/lib/common

export SCHRODINGER_LIB='/software/lib'
export SCHRODINGER='/scr/hoy/build/master'
export SCHRODINGER_SRC='/scr/hoy/source'
export BUILD_LOC='/scr/hoy/build/'
export CONFIG_GUI='/scr/hoy/build/config_gui_build/'

export VENV='/home/hoy/.virtualenvs/venv/'

# ------------------------------------------------------------
# Aliases
# ------------------------------------------------------------

alias xterm='xterm -geometry 100x35'
alias gochroot="sudo chroot /scr/hoy/chroot su -l hoy"
alias buildinger=$SCHRODINGER_SRC/mmshare/build_tools/buildinger.sh
alias ex=exit
alias qqq="gnome-terminal --geometry=100x70"
alias notes="gnome-terminal --working-directory=/home/hoy/notes --geometry=100x35+2200+100"
alias tcode="gnome-terminal --working-directory=/home/hoy/testcode --geometry=100x70+900+0"
alias larger='printf "\e[8;70;100;t"'
alias smaller='printf "\e[8;35;100;t"'
# alias larger="resize -s 70 100"
# alias smaller="resize -s 35 100"
alias review-board="rbt post -o --target-people='toh'"
alias venv="source $VENV/bin/activate" 

setxkbmap -option ctrl:nocaps

designer() {
    source $SCHRODINGER_SRC/mmshare/build_env
    /software/lib/Linux-x86_64/qt-4.8.5/bin/designer
}


