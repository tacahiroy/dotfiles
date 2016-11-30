#!/bin/bash
# .bash_profile

export LANG=en_US.UTF-8

set_path() {
    dir=$1
    if [ -d ${dir} ]; then
        PATH=$PATH:${dir}
    fi
}

if [ -f $HOME/.bash/z.sh ]; then
    _Z_NO_RESOLVE_SYMLINKS=1
    _Z_CMD=j
    . $HOME/.bash/z.sh
fi

EDITOR=vim
PAGER=less

set_path $HOME/.rbenv/bin
set_path $HOME/.local/bin
set_path $HOME/bin
set_path $HOME/.fzf/bin

if [ -d $HOME/go ]; then
    GOPATH=$HOME/go
    PATH=$PATH:$GOPATH/bin
fi

if type -t rbenv 2>&1 >/dev/null; then
    eval "$(rbenv init -)"
fi

# Trigger ~/.bashrc commands
. ~/.bashrc
