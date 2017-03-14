export LANG=en_US.UTF-8

export GOPATH=$HOME/go
export CARGO_PATH=$HOME/.cargo
export RUST_SRC_PATH=/usr/local/src/rust-1.7.0/src
export LC_ALL=$LANG

## path
typeset -U path
path=(
  ./bin
  $HOME/.rbenv/bin(N-/)
  $HOME/.rbenv/shims(N-/)
  $HOME/bin(N-/)
  $HOME/perl5/bin(N-/)
  $HOME/.local/bin(N-/)
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  $GOPATH/bin(N-/)
  $CARGO_PATH/bin(N-/)
  $HOME/Library/Python/2.7/bin(N-/)
  $HOME/.autojump/bin(N-/)
  $HOME/.cargo/bin(N-/)
  $path
)

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
export LESS='-R -g'

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

# Python
typeset -xT PYTHONPATH python_path
typeset -U python_path

python_path=(
  /Library/Python/3.5/site-packages(N-/)
  $HOME/.local/lib/python3.5/site-packages(N-/)
  /usr/local/lib/python3.5/site-packages(N-/)
)

## Perl
typeset -xT PERL5LIB perl5_lib
typeset -U perl5_lib

perl5_lib=(
  $HOME/perl5/lib/perl5(N-/)
)
export PERL_MM_OPT=~/perl5/lib/perl5/local/lib.pm

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
