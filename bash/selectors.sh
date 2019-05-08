#!/usr/bin/env bash

set -Cue

F=${FILTER_CMD:-$HOME/bin/fzy}
FO=${FILTER_OPTIONS:-}
FIND=${FILTER_FIND:-find}
FINDO=${FINDO:--maxdepth 5 ! -path '*/.git/*' -type f}

SELECTOR_HIST_PROMPT_OPT="--prompt=HIST> "
SELECTOR_DIR_PROMPT_OPT="--prompt=CD> "
SELECTOR_FILE_PROMPT_OPT="--prompt=FILE> "
SELECTOR_MRU_PROMPT_OPT="--prompt=MRU> "
SELECTOR_GIT_REPO_PROMPT_OPT="--prompt=REPO> "

which ghq >/dev/null 2>&1 && IS_GHQ=yes || IS_GHQ=no

ghq_root() {
    git config ghq.root | head -1
}

select_history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    READLINE_LINE=$(fc -nl 1 | sed 's/^[\t ]*//g' | \
        eval "${tac}" | \
        ${F} "${FO}" "${SELECTOR_HIST_PROMPT_OPT}")
    READLINE_POINT=${#READLINE_LINE}
}

select_dir() {
    READLINE_LINE="cd $(_z -s 2>&1 | awk '{ print $2 }' | \
        ${F} "${FO}" "${SELECTOR_DIR_PROMPT_OPT}")"
    READLINE_POINT=${#READLINE_LINE}
}

select_file() {
    local cmd=${READLINE_LINE:-${EDITOR:-vim}}

    READLINE_LINE="${cmd} $(${FIND} . "${FINDO}" | \
        ${F} "${FO}" "${SELECTOR_FILE_PROMPT_OPT}")"
    READLINE_POINT=${#READLINE_LINE}
}

# Search MRU file using ctrlp.vim's MRU file list
select_ctrlpvim_mru() {
    local ctrlp_mrufile=$HOME/.cache/ctrlp/mru/cache.txt
    local _file
    if [ -f "${ctrlp_mrufile}" ]; then
        _file=$(${F} "${FO}" "${SELECTOR_MRU_PROMPT_OPT}" <"${ctrlp_mrufile}")
        if [ -n "${_file}" ] && [ -f "${_file}" ]; then
            READLINE_LINE="$EDITOR ${_file}"
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}

# Open ssh connection
select_ssh() {
    local _khost
    local _chost
    _khost=$(grep -o '^\S\+' "$HOME/.ssh/known_hosts" | tr -d '[]' | tr ',' '\n' | sort)
    _chost=$(grep '^Host ' "$HOME/.ssh/config" | sed 's/^Host //' | grep -v '\*\|?' | tr ' ' '\n' | sort)

    if [ -z "${_khost}" ] && [ -z "${_chost}" ]; then
        return
    fi

    local _host
    _host=$(printf "%s\n%s" "${_khost}" "${_chost}" | ${F})

    if [ -z "${_host}" ]; then
        return
    fi

    if [ -n "${_host}" ] && [ -n "${TMUX}" ]; then
        eval "tmux neww -n ${_host} 'ssh ${_host}'"
    else
        eval "ssh ${_host}"
    fi
}

select_git_repo() {
    local list_cmd
    if [ "${IS_GHQ}" = yes ]; then
        list_cmd="ghq list -p"
    else
        list_cmd="find $(ghq_root) -maxdepth 4 -type d -name .git | xargs dirname"
    fi

    local _repo
    _repo=$( (eval "${list_cmd}") | "${F}" "${FO}" "${SELECTOR_GIT_REPO_PROMPT_OPT}" )

    if [ -n "${_repo}" ]; then
        cmdline=${READLINE_LINE:-cd}
        READLINE_LINE="${cmdline} ${_repo}"
        READLINE_POINT=${#READLINE_LINE}
    fi
}

select_git_branch() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo Not a git repository
        return
    fi

    local _is_all
    local _git_branch_opts

    _is_all="$1"
    if [ "${_is_all}" = yes ]; then
        _git_branch_opts="--all"
    fi

    local _branches
    local _branch

    _branches="$(git branch ${_git_branch_opts} | grep -v '\*' | sed 's/^\s*remotes\/origin\///; s/^\s*//' | sort -u)"
    _branch="$(echo "${_branches}" | "${F}" "${FO}" --prompt='BRANCH> ')"

    _branch=${_branch//[[:space:]]}
    if [ -n "${_branch}" ]; then
        if [ "${#READLINE_LINE}" -eq 0 ]; then
            READLINE_LINE="git checkout ${_branch}"
        else
            READLINE_LINE="${READLINE_LINE} ${_branch}"
        fi
        READLINE_POINT=${#READLINE_LINE}
    fi
}

select_git_branch_all() {
    select_git_branch yes
}

bind -x '"\C-r"':"\"select_history\""
bind -x '"\C-t"':"\"select_ctrlpvim_mru\""
bind -x '"\C-gd"':"\"select_dir\""
bind -x '"\C-gf"':"\"select_file\""
bind -x '"\C-gr"':"\"select_git_repo\""
bind -x '"\C-gg"':"\"select_git_branch\""
bind -x '"\C-ga"':"\"select_git_branch_all\""
# bind -x '"\C-q"':"\"select-ssh\""
