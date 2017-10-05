#!/bin/bash
#
# Tacahiroy's bashrc

#--------------------
# Guard
#--------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

umask 0022

# ssh-agent
SSH_ENV=$HOME/.ssh/agent.env
start_agent() {
  ssh-agent > "$SSH_ENV"
  . "$SSH_ENV" > /dev/null
  # ssh-add
}

if [ -f "$SSH_ENV" ]; then
  . "$SSH_ENV" > /dev/null
  if ps ${SSH_AGENT_PID:-999999} | grep ssh-agent$ > /dev/null &&
     test -S "${SSH_AUTH_SOCK}"; then
    # agent already running
    :
  else
    start_agent
  fi
else
  start_agent
fi

unset MAILCHECK

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# After each command, append to the history file and reread it
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=${HISTSIZE}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Filter stuff
if [ -x "$(which peco 2>/dev/null)" ]; then
    FILTER=peco
elif [ -x "$(which fzf 2>/dev/null)" ]; then
    FILTER=fzf
    export FZF_DEFAULT_OPTS='--reverse --inline-info --color=light'
    # [ -f ~/.fzf.bash ] && source ~/.fzf.bash
elif [ -x "$(which percol 2>/dev/null)" ]; then
    FILTER=percol
else
    FILTER=
fi

if [ -n "${FILTER}" ]; then
    # Search history
    select-history() {
        local tac
        if which tac > /dev/null; then
            tac="tac"
        else
            tac="tail -r"
        fi
        READLINE_LINE=$(fc -nl 1 | sed 's/^\t*//' | \
            eval $tac | \
            ${FILTER} --query "$READLINE_LINE")
        READLINE_POINT=${#READLINE_LINE}
    }

    # Search MRU file using ctrlp.vim's MRU file list
    select-ctrlpvim-mru() {
        local ctrlp_mrufile=$HOME/.cache/ctrlp/mru/cache.txt
        local _file
        if [ -f "${ctrlp_mrufile}" ]; then
            _file=$(cat "${ctrlp_mrufile}" | ${FILTER} --query "$READLINE_LINE")
            if [ -n "${_file}" -a -f "${_file}" ]; then
                READLINE_LINE="$EDITOR ${_file}"
                READLINE_POINT=${#READLINE_LINE}
            fi
        fi
    }

    # Open ssh connection
    select-ssh() {
        local _khost=$(grep -o '^\S\+' ~/.ssh/known_hosts | tr -d '[]' | tr ',' '\n' | sort)
        local _chost=$(grep '^Host ' ~/.ssh/config | sed 's/^Host //' | grep -v '\*\|?' | tr ' ' '\n' | sort)

        if [ -z "${_khost}" -a -z "${_chost}" ]; then
            return
        fi

        local _host=$(echo "${_khost}\n${_chost}" | ${FILTER})

        if [ -z "${_host}" ]; then
            return
        fi

        if [ -n "${_host}" -a -n "${TMUX}" ]; then
            eval "tmux neww -n ${_host} 'ssh ${_host}'"
        else
            eval "ssh ${_host}"
        fi
    }
fi

..() {
    if [ $# -eq 0 ]; then
        cd ..
    else
        eval "cd $(printf \"%$1s\" | sed 's/ /..\//g')"
    fi
}


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#--------------------
# Key bindings
#--------------------
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'
bind '"\C-^"':"\"cdup\r\""
if [ -n "${FILTER}" ]; then
    bind -x '"\C-r"':"\"select-history\""
    bind -x '"\C-t"':"\"select-ctrlpvim-mru\""
    # bind -x '"\C-q"':"\"select-ssh\""
fi

#--------------------
# Prompt
#--------------------
PINK='\e[0;35;2m'
ORANGE='\e[0;32;4m'
GREEN='\e[0;33;2m'
RESET='\e[0m'

PROMPT_GIT_STATUS_COLOR="$(tput setaf 28)"
PROMPT_PREPOSITION_COLOR="$(tput setaf 1)"

set_prompt() {
    if [ $(tput colors) = "256" ]; then
        echo -n "${PINK}\u${RESET}@${ORANGE}\h:${GREEN}\w${RESET}"
    else
        echo -n '\u@\h:\w'
    fi
    echo -n '\n'
    echo -n '$ '
}

cdup() {
    cd ..
}

PS1=$(set_prompt)

test -n "$TMUX" && tmux -2 a || tmux -2
source ~/qmk_utils/activate_wsl.sh
