# users generic .zshrc file for zsh(1)

_dot() {
  f=$1
  [ -s "${f}" ] && . "${f}"
}

update_plugins() {
  while read a; do ghq get -u $a; done < ~/.zsh/plugins.txt
}

## plugins
#
if [ -f $HOME/.zsh/plugins.txt ]; then
  unsetopt BG_NICE
  GHQ_GH_ROOT=$(ghq root)/github.com
  while read a; do
    local _repo="${GHQ_GH_ROOT}/${a}"
    if [ ! -d "${_repo}" ]; then
      ghq get "${a}"
    fi
    _dot "${_repo}"
  done < $HOME/.zsh/plugins.txt

  if test -f /proc/version && ! (cat /proc/version | grep Microsoft >/dev/null 2>&1); then
    for y in zsh-users/zsh-autosuggestions olivierverdier/zsh-git-prompt; do
      _dot "${GHQ_GH_ROOT}/${y}"
    done
  fi

  # _dot ${GHQ_GH_ROOT}/olivierverdier/zsh-git-prompt/zshrc.sh

  # _dot ${GHQ_GH_ROOT}/tacahiroy/z/z.sh
  [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && . $HOME/.autojump/etc/profile.d/autojump.sh ]]
  _dot ${GHQ_GH_ROOT}/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

autoload -Uz add-zsh-hook

bindkey -v

# set terminal title including current directory # {{{
case "${TERM}" in
kterm*|xterm*|screen*)
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac # }}}

## ignore case for completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
            /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' cache-path ~/.zsh/cache

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
WORDCHARS=${WORDCHARS:s,/,,}

# stty erase '^H'
stty intr '^C'
stty susp '^Z'

setopt promptsubst

# completion as path after =
setopt magic_equal_subst

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd
# don't push same directory
setopt pushd_ignore_dups

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

# for dir completion. added '/'
setopt auto_param_slash
# add postfix '/' to a directory if completion worked
setopt mark_dirs

setopt complete_in_word
setopt glob_complete
setopt hist_expand

unset menu_complete
setopt auto_list
setopt auto_menu

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

autoload -Uz colors
colors

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
# bindkey "^r" history-incremental-search-backward

# available multibyte characters
setopt print_eight_bit
setopt no_flow_control

## Command history configuration
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=100000

LESS=-XRF

# not save history, starts from space
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# remove duplicated history when save history
setopt hist_save_nodups
# `history` command won't be saved to $HISTFILE
setopt hist_no_store
# trim space when save history
setopt hist_reduce_blanks
# comment after '#'
setopt interactive_comments
# share command history data
setopt share_history
setopt inc_append_history

## Alias configuration# {{{
# expand aliases before completing
# aliased ls needs if file/dir completions work
setopt complete_aliases
# _expand_alias:
zstyle ':completion:*:expand-alias:*' global true
bindkey '^y' _expand_alias

case "${OSTYPE}" in
  freebsd*|darwin*)
    alias vim="$EDITOR "$@""
    alias gvim="$EDITOR -g "$@""
    alias ls='gls -F --color'
    alias o='open'
    alias oo='open .'
    alias bb='brew'
    alias buo='brew update && brew outdated'
    alias netlisten='lsof -nP -iTCP -sTCP:LISTEN'
    alias netestab='lsof -nP -iTCP -sTCP:ESTABLISHED'
    alias -g C='|pbcopy'

    if $(which gdu 2>&1 > /dev/null); then
      alias du="$(which gdu)"
    fi
    ;;
  *)
    alias ls='ls -F --color'
    ;;
esac

alias where='command -v'

alias sl='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias ltr='ls -ltr'
alias llh='ls -lh'
alias rm='nocorrect rm'
alias df='df -h'
alias su='su -l'
alias vi='vim'
alias gg='ghq'
alias git='LC_ALL=en_US.UTF-8 git'
alias gi='git'
alias g='git'
alias gu='git up'
alias gl='git log'
alias pyttpd='python -m http.server'

# global
alias -g L='|$PAGER -R'

setopt complete_aliases

# }}}

## terminal configurations # {{{
#
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  # unset LANG
  # export LSCOLORS=ExFxCxdxBxegedabagacad
  # export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac # }}}

# functions # {{{
# goto parent directory
function cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N cdup
bindkey '^\^' cdup

F=$HOME/bin/fzy
FO='-l 20'

if test -x ${F}; then
  function filter-select-history() {
    local tac
    if which tac > /dev/null; then
      tac="tac"
    else
      tac="tail -r"
    fi
    BUFFER=$(fc -nl 1 | \
      eval $tac | \
      ${F} ${FO} --prompt='HIST> ' --query="$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  function filter-select-ctrlpvim-mru() {
    local ctrlp_mrufile=$HOME/.cache/ctrlp/mru/cache.txt
    local _file
    if [ -f "${ctrlp_mrufile}" ]; then
      _file=$(cat "${ctrlp_mrufile}" | ${F} ${FO} --prompt='MRU> ')
      if [ -n "${_file}" -a -f "${_file}" ]; then
        if [ $#BUFFER -eq 0 ]; then
          BUFFER="vim ${_file}"
        else
          BUFFER="${BUFFER} ${_file}"
        fi
        CURSOR=$#BUFFER
      fi
    fi
    zle reset-prompt
  }

  function filter-ssh() {
    local _khost=$(grep -o '^\S\+' ~/.ssh/known_hosts | grep -v '^|' | tr -d '[]' | tr ',' '\n' | sort)
    local _chost=$(grep '^Host ' ~/.ssh/config | sed 's/^Host //' | grep -v '\*\|?' | tr ' ' '\n' | sort)

    if [ -z "${_khost}" -a -z "${_chost}" ]; then
      return
    fi

    local _host=$(echo "${_khost}\n${_chost}" | ${F} ${FO})

    if [ -z "${_host}" ]; then
      return
    fi

    if [ -n "${_host}" -a -n "${TMUX}" ]; then
      eval "tmux neww -n ${_host} 'ssh ${_host}'"
    else
      eval "ssh ${_host}"
    fi
  }

  function filter-git-repo() {
    if ! which ghq >/dev/null 2>&1; then
      echo ghq is not detected!
      return 9
    fi

    local _repo=$(ghq list -p | ${F} ${FO} --prompt='REPO> ')

    if [ -n "${_repo}" ]; then
      if [ -n "${BUFFER}" ]; then
        BUFFER="${BUFFER} ${_repo}"
      else
        BUFFER="cd ${_repo}"
      fi
      CURSOR=$#BUFFER
    fi
    zle reset-prompt
  }

  function filter-git-branch() {
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
    _branch="$(echo ${_branches} | ${F} ${FO} --prompt='BRANCH> ')"

    _branch=${_branch//[[:space:]]}
    if [ -n "${_branch}" ]; then
      if [ $#BUFFER -eq 0 ]; then
        BUFFER="git checkout ${_branch}"
      else
        BUFFER="${BUFFER} ${_branch}"
      fi
      CURSOR=$#BUFFER
    fi
    zle reset-prompt
  }

  function filter-git-branch-all() {
    filter-git-branch yes
  }

  function filter-cd-hist() {
    local ctrlp_cache=$HOME/.cache/ctrlp/mru/cache.txt
    ! test -f ${ctrlp_cache} && return

    local _dir=$(sed 's#/[^/]\+$##' ${ctrlp_cache} | sort -u | ${F} ${FO} --prompt='JUMP> ')
    if [ -n "${_dir// }" ]; then
      if [ $#BUFFER -eq 0 ]; then
        BUFFER="cd ${_dir}"
      else
        BUFFER="${BUFFER} ${_dir}"
      fi
    fi
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  function filter-dirs() {
    local _dir=$(find . -type d ! -name '.git' ! -path '*/.git/*' ! -name '.' | ${F} ${FO} --prompt='JUMP> ')
    if [ -n "${_dir// }" ]; then
      if [ $#BUFFER -eq 0 ]; then
        BUFFER="cd ${_dir}"
      else
        BUFFER="${BUFFER} ${_dir}"
      fi
    fi
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  function filter-files {
    local _file=$(rg --files --no-heading | ${F} ${FO} --prompt='FILE> ')
    if [ -n "${_file// }" ]; then
      if [ $#BUFFER -eq 0 ]; then
        BUFFER="vim ${_file}"
      else
        BUFFER="${BUFFER} ${_file}"
      fi
    fi
    CURSOR=$#BUFFER
    zle reset-prompt
  }

  zle -N filter-ssh
  bindkey '^q' filter-ssh

  zle -N filter-select-history
  bindkey '^r' filter-select-history

  zle -N filter-select-ctrlpvim-mru
  bindkey '^t' filter-select-ctrlpvim-mru

  zle -N filter-git-repo
  bindkey '^gr' filter-git-repo

  zle -N filter-git-branch
  bindkey '^gb' filter-git-branch

  zle -N filter-git-branch-all
  bindkey '^gB' filter-git-branch-all

  zle -N filter-cd-hist
  bindkey '^gj' filter-cd-hist

  zle -N filter-dirs
  bindkey '^gd' filter-dirs

  zle -N filter-files
  bindkey '^gf' filter-files
fi
# }}}

autoload zmv
alias zmv='noglob zmv -W'

# autoload predict-on
# predict-on

## Completion configuration
autoload -Uz compinit && compinit -u

## {{{ PROMPT
#
set_prompt() {
  echo -n "%F{213}%n"
  echo -n "%{${reset_color}%}@"
  echo -n "%F{208}%m"
  echo -n "%{${reset_color}%}:"
  echo -n "%{${fg[green]}%}%~%{${reset_color}%} "
  if type git_super_status 2>&1 >/dev/null; then
    echo '$(git_super_status)'
  else
    echo
  fi
  echo -n "%% "
}

case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/ ${fg[green]}#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[cyan]}%}%n%{${reset_color}%}@%{${fg[yellow]}%}%m%{${reset_color}%}:${PROMPT}"

  [ -n "${SSH_CONNECTION}" ] &&
      PROMPT="%{${fg[blue]}%}%3v%{${reset_color}%}"
  ;;
*)
  PROMPT=$(set_prompt)
  PROMPT2="%{${fg[red]}%}%_%{${reset_color}%}%% "
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}"

  [ -n "${SSH_CONNECTION}" ] &&
      RPROMPT="%{${fg[blue]}%}%3v%{${reset_color}%}"

  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
      PROMPT="%{${fg[magenta]}%}%n%{${reset_color}%}@%{${fg[yellow]}%}%m%{${reset_color}%}:${PROMPT}"
  ;;
esac # }}}

if [ -x "$(which brew)" ]; then
  BREW_PREFIX=$(brew --prefix)

  for z in ${BREW_PREFIX}/opt/awscli/share/zsh/site-functions/_aws \
           ~/.zsh/functions/zsh-utils; do
    [ -s ${z} ] && . ${z}
  done
fi

# __END__
# vim: et ts=2 sts=2 sw=2 fdm=marker
