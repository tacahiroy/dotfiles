#!/usr/bin/env bash

umask 0022

set_path() {
    dir=$1
    prioritise=$2
    if [ -d "${dir}" ]; then
        if echo "$PATH" | tr ':' '\n' | grep "${dir}" >/dev/null 2>&1; then
            return
        fi

        if [ -n "${prioritise}" ]; then
            PATH=${dir}:$PATH
        else
            PATH=$PATH:${dir}
        fi
    fi
}

case "$(uname -r)" in
    MSYS*) PLATFORM=msys;;
    *microsoft*|*Microsoft*) PLATFORM=wsl;;
    *Darwin*) PLATFORM=macos;;
    *) PLATFORM=linux;;
esac
export PLATFORM

export LANG=en_US.UTF-8
export SHELL=/bin/bash
export GIT_ROOT=$HOME/dev/src
GOPATH=$(dirname "${GIT_ROOT}")
export GOPATH
export EDITOR=vim
export PAGER=less
export LESS='-R'

set_path "$HOME/bin" 1
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/bin" 1
set_path "$HOME/.yarn/bin"
set_path "$HOME/.pulumi/bin"
set_path "$HOME/.rbenv/bin"
set_path "$HOME/.rbenv/shims"

export PATH

r=$(command -v fzy)
if [ -n "${r}" ]; then
    FILTER_CMD="${r}"
    FILTER_OPTIONS='-l 20'
    export FILTER_CMD FILTER_OPTIONS
fi

fd=$(command -v fd 2>/dev/null)
if [ -n "${fd}" ]; then
    FIND="${fd}"
    FINDO=
    export FIND FINDO
fi

# Enable plugin cache dir for Terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export SHELLCHECK_OPTS="-e SC2016 -e SC1090"
export GO111MODULE=on

if [ -f "$HOME/.bash_aliases" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.bash_aliases"
fi

export WORKON_HOME=$HOME/.venvs
export PROJECT_HOME=$HOME/dev/src

if [ -f "$HOME/.local/bin/virtualenvwrapper.sh" ]; then
    # shellcheck source=/dev/null
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export WORKON_HOME=~/.virtualenvs
    . "$HOME/.local/bin/virtualenvwrapper.sh"
fi

if [ "${PLATFORM}" = wsl ]; then
    DISPLAY=$(awk '/^nameserver/ { print $2 }' /etc/resolv.conf):0
    export DISPLAY
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
