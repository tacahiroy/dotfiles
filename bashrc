#!/usr/bin/env bash
#
# Tacahiroy's bashrc
#
# Copyright © 2022 Takahiro Yoshihara <tacahiroy@gmail.com>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

umask 0022

if [ -e "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
fi

#--------------------
# Guard
#--------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if command -v ghq >/dev/null 2>&1; then
    GIT_CMD=$(command -v ghq)
    IS_PURE_GIT=no
else
    GIT_CMD=$(command -v git)
    IS_PURE_GIT=yes
fi

#---------------------
# Functions
#---------------------

_dot() {
  f=$1
  # shellcheck source=/dev/null
  [ -s "${f}" ] && . "${f}"
}

update_plugins() {
  while read -r a; do ghq get -u "${a}" >/dev/null 2>&1; done < "$HOME/.bash/plugins.txt"
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
    update_plugins
}

cdup() {
    cd ..
}

srol() {
    if [ ! -f ./meta/main.yml ]; then
        echo "The current directory dosen't look like an Ansible role's directory: $(readlink -f .)"
        return 1
    fi

    local role_name
    role_name="$(basename "$(readlink -f .)")"

    echo "Synchronising ${role_name} to $HOME/.ansible/roles"
    rsync -av --no-p -p --exclude '.git' --exclude '.git/*' --delete . "$HOME/.ansible/roles/${role_name}"
}

## plugins
#
setup_plugins() {
    if [ -z "${GIT_CMD}" ]; then
        echo "Git was not found on your system."
        return 1
    fi

    if [ -z "${GIT_ROOT}" ]; then
        echo "GIT_ROOT is not set."
        return 1
    fi

    if [ -f "$HOME/.bash/plugins.txt" ]; then
        while read -r a; do
            local _rn _init _repo
            _rn=$(echo "${a}" | awk '{ print $1 }')
            _init=$(echo "${a}" | awk '{ print $2 }')
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

#--------------------
# Prompt
#--------------------
if [ -f "$HOME/.bash/prompt.sh" ]; then
    git_status="${GIT_ROOT}/github.com/romkatv/gitstatus"
    if [ -d "${git_status}" ]; then
        # shellcheck source=/dev/null
        . "${git_status}/gitstatus.prompt.sh"
        extras='${GITSTATUS_PROMPT:+(${GITSTATUS_PROMPT})}'
    fi

    # shellcheck source=~/.bash/prompt.sh
    . "$HOME/.bash/prompt.sh"
    set_prompt "${BRIGHT_RED}" "${GREEN}" "${BLUE}" "${extras:-}"
fi

unset MAILCHECK

FIGNORE="${FIGNORE}:@tmp:retry:tfstate:backup"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend
# automatic spell correction for cd
shopt -s cdspell

# After each command, append to the history file and reread it
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=${HISTSIZE}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

case "${PLATFORM}" in
    macos)
        ;;
    *)
        # If set, the pattern "**" used in a pathname expansion context will
        # match all files and zero or more directories and subdirectories.
        shopt -s globstar
        ;;
esac

if [ -f "$HOME/.bashrc.local" ]; then
    # shellcheck source=~/.bashrc.local
    . "$HOME/.bashrc.local"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

..() {
    if [ $# -eq 0 ]; then
        cd ..
    else
        eval "cd $(printf \"%"$1"s\" | sed 's/ /..\//g')"
    fi
}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  fi

  if [ -f /etc/bash_completion ]; then
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

case "${PLATFORM}" in
    # NOTE: the version of ssh is too new on Void Linux, which is 9.0p1, and it fails
    # to retrieve an identity from older versions of ssh-agent.
    wsl)
        # https://github.com/rupor-github/wsl-ssh-agent/tree/5fe57762c#wsl-2-compatibility
        export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
        if ! ss -a | grep -q "${SSH_AUTH_SOCK}"; then
            rm -f "${SSH_AUTH_SOCK}"
            ( setsid socat UNIX-LISTEN:"${SSH_AUTH_SOCK}",fork,umask=007 EXEC:"$HOME/winhome/.wsl/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
        fi
        ;;

    macos|linux)
        if ! pgrep ssh-agent >/dev/null; then
            eval "$(ssh-agent)"
        fi
        ;;

    *)
        ;;
esac

if [ "${PLATFORM}" = wsl ] && [ -x "$HOME/bin/tmp-clean.sh" ]; then
    bash "$HOME"/bin/tmp-clean.sh
fi

if [ -f "$HOME/.bashrc.local" ]; then
    # shellcheck source=~/.bashrc.local
    . "$HOME/.bashrc.local"
fi

if [ -n "${FILTER_CMD}" ]; then
    # shellcheck source=/dev/null
    [ -f "$HOME/.bash/selectors.sh" ] && . "$HOME/.bash/selectors.sh"
fi

[[ -x $(command -v tmux) && -z "$TMUX" && "$USE_TMUX" = yes ]] && {
    [ "$ATTACH_ONLY" = yes ] && {
        tmux -2 new-window -l -c "$PWD" 2>/dev/null && exec tmux -2 a
        exec tmux -l2
    }
}

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init bash)"

# Adding wsl-open as a browser for Bash for Windows
if [[ $(uname -r) =~ (m|M)icrosoft ]]; then
    if [[ -z $BROWSER ]]; then
        export BROWSER=wsl-open
    else
        export BROWSER=$BROWSER:wsl-open
    fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
# shellcheck source=/dev/null
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && . "$HOME/.sdkman/bin/sdkman-init.sh"

if [[ -x $(command -v kubectl) ]]; then
    . <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
fi
. "$HOME/.cargo/env"
