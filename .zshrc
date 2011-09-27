# Created by newuser for 4.3.4
# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#
#export LANG=ja_JP.UTF-8
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export RUBYOPT=-rubygems
#export RUBYLIB=$HOME/lib/ruby:$HOME/ruby/gems
export GEM_HOME=/usr/local/Cellar/gems/1.9
export TERM=xterm-256color
# colorize
export LV='-c'

DEFAULT_PROMPT=$PROMPT

## git
typeset -ga chpwd_functions
typeset -ga preexec_functions

function set_prompt_git() {
  local git_branch
  local dirty
  local head

  head=$(git rev-parse --short HEAD 2> /dev/null)
  $(git status 2> /dev/null | grep '^nothing to commit' > /dev/null)
  if [ $? != '0' ]; then
      dirty='*'
  fi

  git_branch="${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/}"

  if [ $? != '0' ]; then
      PROMPT="${DEFAULT_PROMPT}"
  else
      PROMPT="${DEFAULT_PROMPT}on [%{${fg[green]}%}${git_branch}(${head})${fg[red]}${dirty}%{${reset_color}%}] "
  fi
}
chpwd_functions+=set_prompt_git
preexec_functions+=set_prompt_git
setopt promptsubst
autoload -U promptinit
promptinit

## ignore case for completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=1

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
            /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
*)
  PROMPT="%{${fg[red]}%}%/%{${reset_color}%}%% "
  PROMPT2="%{${fg[red]}%}%_%{${reset_color}%}%% "
  SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}"
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
esac

# completion as path after =
setopt magic_equal_subst

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
# to end of it)
bindkey -v

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# available multibyte characters
setopt print_eight_bit
setopt no_flow_control

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_space # not save history, starts from space
setopt hist_ignore_all_dups
setopt hist_save_nodups # remove duplicated history when save history
setopt share_history # share command history data
setopt hist_reduce_blanks # trim space when save history
setopt interactive_comments # comment after '#'

## Completion configuration
autoload -U compinit
compinit

## Alias configuration
# expand aliases before completing
setopt complete_aliases # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -FG -w"
  ;;
linux*)
  alias ls="ls -F --color"
  ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias ltr="ls -ltr"

alias du="du -h"
alias df="df -h"
alias su="su -l"

alias v="vim"
alias vv="mvim"

alias -g KK="|xargs kill -9"

alias -g L='|lv'
alias -g G='|grep'

## terminal configuration
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
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac
# __END__

