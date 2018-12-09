#!/bin/bash

umask 0022

set_path() {
    dir=$1
    if [ -d "${dir}" ]; then
        PATH=$PATH:${dir}
    fi
}

export LANG=en_US.UTF-8
export SHELL=/bin/bash
export GOPATH=$HOME/go
export EDITOR=vim
export PAGER=less
export FILTER_CMD=$HOME/bin/fzy
export FILTER_OPTIONS='-l 20'

export DISPLAY=:0

set_path "$HOME/bin"
set_path "$HOME/.local/bin"
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"

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
