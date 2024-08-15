#!/usr/bin/env bash
#
# Tacahiroy's bash_profile
#
# Copyright © 2022-2024 Takahiro YOSHIHARA <tacahiroy@gmail.com>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# shellcheck disable=SC1090,SC1091

umask 0022

set_path() {
    local dir=$1
    local priotiry=$2

    if [ ! -d "${dir}" ]; then
        return
    fi

    if echo "$PATH" | tr ':' '\n' | grep "${dir}" >/dev/null 2>&1; then
        return
    fi

    if [ -n "${priotiry}" ]; then
        PATH=${dir}:$PATH
    else
        PATH=$PATH:${dir}
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
set_path "$HOME/.local/bin" 1
set_path "$HOME/.cargo/bin"
set_path "$GOPATH/bin"
set_path "/usr/local/bin"
set_path "$HOME/.yarn/bin"
set_path "$HOME/.npm-global/bin" 1
set_path "$HOME/opt/vim/bin" 1
set_path "${KREW_ROOT:-$HOME/.krew}/bin"

[ -f "$HOME"/.cargo/env ] && . "$HOME/.cargo/env"

export PATH

r=$(command -v sk)
if [ -n "${r}" ]; then
    FILTER_CMD="${r}"
    # sk
    # FILTER_OPTIONS='--height 50% --reverse'
    # fzy
    FILTER_OPTIONS='--lines 20 --show-scores --show-info'
    export FILTER_CMD FILTER_OPTIONS
fi

fd=$(command -v fd 2>/dev/null)
if [ -n "${fd}" ]; then
    FIND="${fd}"
    FINDO=
    export FIND FINDO
fi

export SHELLCHECK_OPTS="-e SC2016 -e SC1090"

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    set_path "$PYENV_ROOT/bin"
    eval "$(pyenv init --path)"
fi

if [ -d "$HOME/.rye" ]; then
    . "$HOME/.rye/env"
fi

if [ "${PLATFORM}" = wsl ] && [ ! -d /wslg ]; then
    DISPLAY=$(awk '/^nameserver/ { print $2 }' /etc/resolv.conf):0
    export DISPLAY
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        # shellcheck source=~/.bashrc
        . "$HOME/.bashrc"
    fi
fi

if [ -f "$HOME/.bash_aliases" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.bash_aliases"
fi

if command -v aws >/dev/null 2>&1; then
    complete -C aws_completer aws
fi

if command -v terraform >/dev/null 2>&1; then
    complete -C "$(command -v terraform)" terraform
    # Enable plugin cache dir for Terraform
    export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
fi

if command -v kubectl >/dev/null; then
    # shellcheck source=/dev/null
    . <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
fi

if command -v zoxide >/dev/null; then
    # https://github.com/ajeetdsouza/zoxide
    eval "$(zoxide init --cmd z bash)"
fi
