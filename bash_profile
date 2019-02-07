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

export LANG=en_US.UTF-8
export SHELL=/bin/bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export EDITOR=vim
export PAGER=less
r=$(which fzy >/dev/null 2>&1)
if [ -x "${r}" ]; then
    export FILTER_CMD="${r}"
    export FILTER_OPTIONS='-l 20'
fi
# export FILTER_CMD=$HOME/.cargo/bin/rff
# export FILTER_OPTIONS='-s'

export DISPLAY=:0

set_path "$HOME/bin" 1
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/go/bin" 1
export PATH

if go version | grep go1.11 >/dev/null 2>&1; then
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
