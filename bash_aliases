case "$OSTYPE" in
    darwin*)
        alias ls='ls -pG'
        ;;
    *)
        alias ls='ls -F --color'
        ;;
esac

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias ltr='ls -ltr'
alias llh='ls -lh'
alias sl='ls'
alias gi='git'
alias vi='vim'
alias where='command -v'
alias df='df -h'
alias git='LC_ALL=en_US.UTF-8 git'
alias gi='git'
alias g='git'
alias gu='git up'
alias gl='git log'
alias pyttpd='python3 -m http.server'
alias tfm=terraform
alias lines='grep -c ""'
if [ "${MYOS}" = "wsl" ]; then
    alias rg='rg -j1'
fi

if type _z >/dev/null 2>&1; then
    alias jc='_z -c'
fi
