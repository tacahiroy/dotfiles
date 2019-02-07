#!/usr/bin/env bash
#
# Tacahiroy's bashrc

umask 0022

#--------------------
# Guard
#--------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

case "$(uname -a)" in
    MSYS*) MYOS=msys;;
    *Microsoft*) MYOS=wsl;;
    *Darwin*) MYOS=macos;;
    *) MYOS=linux;;
esac

_dot() {
  f=$1
  # shellcheck source=/dev/null
  [ -s "${f}" ] && . "${f}"
}

update_plugins() {
  while read -r a; do ghq get -u "${a}"; done < "$HOME/.bash/plugins.txt"
}

is_ssh_agent_running() {
    ps aux | grep -q [s]sh-agent
}

if which ghq >/dev/null 2>&1; then
    GIT_CMD=$(which ghq)
    IS_PURE_GIT=no
else
    GIT_CMD=$(which git)
    IS_PURE_GIT=yes
fi

get_git_root() {
    if [ "${IS_PURE_GIT}" = yes ]; then
        "${GIT_CMD}" config ghq.root | head -1
    else
        "${GIT_CMD}" root
    fi
}

git_clone() {
    url=$1
    dest=$2

    if [ "${IS_PURE_GIT}" = yes ]; then
        "${GIT_CMD}" clone  "${url}" "${dest}"
    else
        "${GIT_CMD}" get "${url}"
    fi
}

## plugins
#
export _Z_CMD=j
if [ -x "${GIT_CMD}" ] && [ -f "$HOME/.bash/plugins.txt" ]; then
    GIT_ROOT=$(get_git_root)/github.com
    while read -r a; do
        _rn=$(echo "${a}" | cut -d ' ' -f1)
        _init=$(echo "${a}" | cut -d ' ' -f2)
        _repo="${GIT_ROOT}/${_rn}"
        if [ ! -d "${_repo}" ]; then
            git_clone https://github.com/"${_rn}" "${_repo}"
        fi

        PATH=$PATH:"${_repo}"

        if [ -f "${_repo}/${_init}" ]; then
            _dot "${_repo}/${_init}"
        fi
    done < "$HOME/.bash/plugins.txt"
fi

# ssh-agent
SSH_ENV=$HOME/.ssh/agent.env
start_agent() {
  ssh-agent > "${SSH_ENV}"
  # shellcheck source=/dev/null
  . "${SSH_ENV}" > /dev/null
  # ssh-add
}

if [ -f "${SSH_ENV}" ]; then
  # shellcheck source=/dev/null
  . "${SSH_ENV}" > /dev/null
  if is_ssh_agent_running > /dev/null && test -S "${SSH_AUTH_SOCK}"; then
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
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=${HISTSIZE}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

case "${MYOS}" in
    macos)
        ;;
    *)
        # If set, the pattern "**" used in a pathname expansion context will
        # match all files and zero or more directories and subdirectories.
        shopt -s globstar
        ;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -n "${FILTER_CMD}" ]; then
    # shellcheck source=/dev/null
    [ -f "$HOME/.bash/selectors.sh" ] && . "$HOME/.bash/selectors.sh"
fi

..() {
    if [ $# -eq 0 ]; then
        cd ..
    else
        eval "cd $(printf \"%"$1"s\" | sed 's/ /..\//g')"
    fi
}


if [ -f "$HOME/.bash_aliases" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.bash_aliases"
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

cdup() {
    cd ..
}

#--------------------
# Prompt
#--------------------
PINK='\e[0;35;5m'
MIDORI='\e[0;32;4m'
AO='\e[0;36;5m'
RESET='\e[0m'

set_prompt() {
    if [ "$(tput colors)" = "256" ]; then
        echo -n "${PINK}\u${RESET}@${MIDORI}\h:${AO}\w${RESET}"
    else
        echo -n '\u@\h:\w'
    fi
    printf '\n$ '
}

PS1=$(set_prompt)

case "$(uname -a)" in
        MSYS*)
        if [ -f "$HOME/qmk_utils/activate_msys2.sh" ]; then
            # shellcheck source=/dev/null
            . "$HOME/qmk_utils/activate_msys2.sh"
        fi
        ;;
        *Microsoft*)
        if [ -f "$HOME/qmk_utils/activate_wsl.sh" ]; then
            # shellcheck source=/dev/null
            . "$HOME/qmk_utils/activate_wsl.sh"
        fi
        ;;
        *Darwin*)
        ;;
        *)
        ;;
esac

# If use_tmux=1, add these codes to .bashrc/.zshrc:
ATTACH_ONLY=1
USE_TMUX=1
if which tmux >/dev/null 2>&1; then
    [[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
        [[ -n "$ATTACH_ONLY" ]] && {
            tmux -2 a 2>/dev/null || {
                cd && exec tmux -l2
            }
            exit
        }
        tmux -2 new-window -l -c "$PWD" 2>/dev/null && exec tmux -2 a
        exec tmux -l2
    }
fi

if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.local/bin/virtualenvwrapper.sh"
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export WORKON_HOME=~/.virtualenvs
fi

if [ "${MYOS}" = wsl ] && [ -x "$HOME/bin/tmp-clean.sh" ]; then
    bash "$HOME"/bin/tmp-clean.sh
fi
