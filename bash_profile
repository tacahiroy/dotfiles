#!/bin/bash

umask 0022

set_path() {
    dir=$1
    prioritise=$2
    if [ -d "${dir}" ]; then
        if echo "$PATH" | tr ':' '\n' | grep "${dir}"; then
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
export FILTER_CMD=$(which fzy)
export FILTER_OPTIONS='-l 20'
# export FILTER_CMD=$HOME/.cargo/bin/rff
# export FILTER_OPTIONS='-s'

export DISPLAY=:0

set_path "$HOME/bin" 1
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/go/bin" 1

export PATH

if [[ "$(uname -s)" =~ MSYS_NT.* ]]; then
    export GOROOT=/c/tools/msys64/mingw64/lib/go
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

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
