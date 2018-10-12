#!/bin/bash
# .bash_profile

export LANG=en_US.UTF-8

set_path() {
    dir=$1
    if [ -d "${dir}" ]; then
        PATH=$PATH:${dir}
    fi
}

set_path "$HOME/.local/bin"
set_path "$HOME/bin"
set_path "$HOME/.cargo/bin"

if [ -d "$HOME/go" ]; then
    GOPATH=$HOME/go
    set_path "$GOPATH"
fi

export EDITOR=vim
export PAGER=less
export PATH

if [[ "$(uname -s)" =~ "MSYS_NT.*" ]]; then
    export GOROOT=/c/tools/msys64/mingw64/lib/go
fi
export GOPATH=$HOME/go

# Trigger ~/.bashrc commands
. ~/.bashrc
