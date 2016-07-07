# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bashrc ]; then
     . /etc/bashrc   # --> Read /etc/bashrc, if present
fi

# ----------------------------------------------------
# Prompt format
# ----------------------------------------------------

PS1="[\u@\h\[\033[33m\]\$(git branch 2>/dev/null | grep '\*' | sed -e 's/../ /')\[\033[0m\] \W]\\$ "

# ----------------------------------------------------
# History settings
# ----------------------------------------------------

HISTFILESIZE=10000000
HISTSIZE=10000
export HISTIGNORE="cd:ls:clear:exit:bg:fg:&"
export HISTCONTROL=ignoredups

# ----------------------------------------------------
# UI Settings
# ----------------------------------------------------

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export LANG=en_US
shopt -s checkwinsize # Resize COLUMNS and LINES if needed after commands
eval "$(lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# ----------------------------------------------------
# Aliases
# ----------------------------------------------------

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ex=exit
alias qqq="gnome-terminal --geometry=100x70"
alias larger='printf "\e[8;70;100;t"'
alias smaller='printf "\e[8;35;100;t"'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

