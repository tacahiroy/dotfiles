export LANG=en_US.UTF-8

export GOPATH=$HOME/go
export CARGO_PATH=$HOME/.cargo
export LC_ALL=$LANG

export SHELL=/usr/bin/zsh

export DISPLAY=:0

## path
typeset -U path
path=(
  ./bin
  $HOME/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/perl5/bin(N-/)
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  $GOPATH/bin(N-/)
  $CARGO_PATH/bin(N-/)
  $HOME/Library/Python/2.7/bin(N-/)
  $HOME/lib/jdk1.8.0_121/bin(N-/)
  $HOME/sqlcl/bin(N-/)
  $path
)

# JAVA_HOME=$HOME/lib/jdk1.8.0_121

fpath=(/usr/local/opt/zsh-completions/share/zsh-completions/(N-/) \
       $HOME/.zsh/functions/*(N-) \
       $HOME/.zsh/vendor/*(N-) \
       $fpath)
typeset -U fpath

# tmux-powerline
case "${OSTYPE}" in
  freebsd*|darwin*)
    export PLATFORM="mac"
    ;;
  *)
    export PLATFORM="linux"
    ;;
esac
export USE_PATCHED_FONT="false"

## Environment variable configuration
#
# LANG
#
# export LANG=ja_JP.UTF-8
# export TERM=xterm-256color
if [ -n ${TMUX} ]; then
  export TERM=screen-256color
else
  export TERM=xterm-256color
fi

export PAGER='less'
export LESS='-FRSX -g'

if [ -x "$(which vim)" ]; then
  export EDITOR=vim
fi

export ANDROID_HOME=/usr/local/opt/android-sdk

## Ruby
typeset -xT RUBYLIB ruby_path
typeset -U ruby_path

ruby_path=(
  ./lib(N-/)
  $HOME/lib/ruby(N-/)
)

# # Python
# typeset -xT PYTHONPATH python_path
# typeset -U python_path

# python_path=(
#   /Library/Python/3.5/site-packages(N-/)
#   $HOME/.local/lib/python3.5/site-packages(N-/)
#   /usr/local/lib/python3.5/site-packages(N-/)
# )

## Perl
typeset -xT PERL5LIB perl5_lib
typeset -U perl5_lib

perl5_lib=(
  $HOME/perl5/lib/perl5(N-/)
)
export PERL_MM_OPT=~/perl5/lib/perl5/local/lib.pm

if [ -f ~/.zshrc.local ]; then
  . ~/.zshrc.local
fi

VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source $HOME/.local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs
