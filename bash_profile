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

if uname | grep 'MSYS' >/dev/null 2>&1; then
    IS_MSYS=yes
else
    IS_MSYS=no
fi

export LANG=en_US.UTF-8
export SHELL=/bin/bash
export GIT_ROOT=$HOME/dev/src
if [ "${IS_MSYS}" = yes ]; then
    export GOROOT=/mingw64/lib/go
fi
GOPATH=$(dirname "${GIT_ROOT}")
export GOPATH
export EDITOR=vim
export PAGER=less

export DISPLAY=:0

set_path "$HOME/bin" 1
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/bin" 1
set_path "$HOME/.yarn/bin"

if [ "${IS_MSYS}" = yes ]; then
    set_path "/mingw64/bin"
fi

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

if go version | grep 'go1.1[1-9]' >/dev/null 2>&1; then
    export GO111MODULE=on
fi

if [[ "$(uname -s)" =~ MSYS_NT.* ]]; then
    # export GOROOT=/c/tools/msys64/mingw64/lib/go
    :
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
