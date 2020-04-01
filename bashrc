#!/usr/bin/env bash
#
# Tacahiroy's bashrc

umask 0022

#--------------------
# Prompt
#--------------------
if [ -f "$HOME/.bash/prompt.sh" ]; then
    . "$HOME/.bash/prompt.sh"
    set_prompt "${RED}" "${GREEN}" "${BLUE}"
fi

if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi

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

if command -v ghq >/dev/null 2>&1; then
    GIT_CMD=$(command -v ghq)
    IS_PURE_GIT=no
else
    GIT_CMD=$(command -v git)
    IS_PURE_GIT=yes
fi

_dot() {
  f=$1
  # shellcheck source=/dev/null
  [ -s "${f}" ] && . "${f}"
}

update_plugins() {
  while read -r a; do ghq get -u "${a}" >/dev/null 2>&1; done < "$HOME/.bash/plugins.txt"
}

is_ssh_agent_running() {
    pgrep ssh-agent >/dev/null 2>&1
}

git_clone() {
    local url=$1
    local dest=$2

    if [ "${IS_PURE_GIT}" = yes ]; then
        git clone  "${url}" "${dest}"
    else
        ghq get "${url}"
    fi
  [ ! -x "$(command -v ghq)" ] && return
  while read -r a; do ghq get -u "${a}"; done < "$HOME/.bash/plugins.txt"
}

## plugins
#
setup_plugins() {
    if [ ! -x "${GIT_CMD}" ]; then
        echo "Git was not found on your system."
        return 1
    fi

    if [ -z "${GIT_ROOT}" ]; then
        echo "GIT_ROOT is not set."
        return 1
    fi

    export _Z_CMD=j
    if [ -f "$HOME/.bash/plugins.txt" ]; then
        while read -r a; do
            local _rn _init _repo
            _rn=$(echo "${a}" | awk -F ' ' '{ print $1 }')
            _init=$(echo "${a}" | awk -F ' ' '{ print $2 }')
            _repo="${GIT_ROOT}/${_rn}"

            if [ ! -d "$(readlink -f "${_repo}")" ]; then
                git_clone "https://${_rn}" "${_repo}"
            fi

            PATH=$PATH:"${_repo}"

            [ -z "${_init}" ] && continue
            _dot "${_repo}/${_init}"
        done < "$HOME/.bash/plugins.txt"
    fi
}

setup_plugins

srol() {
    if [ ! -f meta/main.yml ]; then
        echo "The current directory dosen't look like an Ansible role's directory: $(readlink -f .)"
        return 1
    fi

    role_name="$(basename "$(readlink -f .)")"
    echo "Synchronising ${role_name} to $HOME/.ansible/roles"
    rsync -av --no-p -p --exclude '.git' --exclude '.git/*' --delete . "$HOME/.ansible/roles/${role_name}"
}

unset MAILCHECK

FIGNORE="${FIGNORE}:@tmp:retry:tfstate:backup"

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
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi
fi

#--------------------
# Key bindings
#--------------------
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'
bind '"\C-y"':"\"cdup\r\""

cdup() {
    cd ..
}

case "${MYOS}" in
    msys)
        if [ -f "$HOME/qmk_utils/activate_msys2.sh" ]; then
            # shellcheck source=/dev/null
            . "$HOME/qmk_utils/activate_msys2.sh"
        fi
        ;;
    wsl)
        [ -z "${SSH_AUTH_SOCK}" ] && eval "$(ssh-agent)"

        if [ -f "$HOME/qmk_utils/activate_wsl.sh" ]; then
            # shellcheck source=/dev/null
            . "$HOME/qmk_utils/activate_wsl.sh"
        fi
        ;;
    macos)
        ;;
    *)
        ;;
esac

if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    # shellcheck source=/dev/null
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export WORKON_HOME=~/.virtualenvs
    . "$HOME/.local/bin/virtualenvwrapper.sh"
fi

if [ "${MYOS}" = wsl ] && [ -x "$HOME/bin/tmp-clean.sh" ]; then
    bash "$HOME"/bin/tmp-clean.sh
fi

if command -v aws >/dev/null 2>&1; then
    complete -C aws_completer aws
fi

[[ -x $(command -v tmux) && -z "$TMUX" && "$USE_TMUX" = yes ]] && {
    [ "$ATTACH_ONLY" = yes ] && {
        tmux -2 a 2>/dev/null || {
            cd && exec tmux -l2
        }
        tmux -2 new-window -l -c "$PWD" 2>/dev/null && exec tmux -2 a
        exec tmux -l2
    }
}
