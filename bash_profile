#!/usr/bin/env bash

umask 0022

if uname | grep 'MSYS' >/dev/null 2>&1; then
    IS_MSYS=yes
else
    IS_MSYS=no
fi

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

export LANG=en_US.UTF-8
export SHELL=/bin/bash
export GIT_ROOT=$HOME/dev/git/src
export GOPATH=$(dirname ${GIT_ROOT})
export EDITOR=vim
export PAGER=less
r=$(which fzy)
if [ -x "${r}" ]; then
    export FILTER_CMD="${r}"
    export FILTER_OPTIONS='-l 20'
fi
fd=$(which fd)
if [ -x "${fd}" ]; then
    export FIND="${fd}"
    export FINDO=
fi

export DISPLAY=:0

set_path "$HOME/bin" 1
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/go/bin" 1
set_path "$HOME/.yarn/bin"

if [ "${IS_MSYS}" = yes ]; then
    set_path "/mingw64/bin"
fi

export PATH

export SHELLCHECK_OPTS="-e SC2016 -e SC1090"

if go version | grep 'go1.1[1-9]' >/dev/null 2>&1; then
    export GO111MODULE=on
fi

if [[ "$(uname -s)" =~ MSYS_NT.* ]]; then
    # export GOROOT=/c/tools/msys64/mingw64/lib/go
    :
fi

if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
