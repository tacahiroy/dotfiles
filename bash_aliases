if alias vim >/dev/null 2>&1; then
	unalias vim
fi

if command -v lsd >/dev/null 2>&1; then
    alias ls=lsd
    alias ll='ls -lg'
    alias lg='ll'
else
    alias ll='ls -l'
fi
alias la='ls -a'
alias lla='ll -a'
alias ltr='ll -tr'
alias gi='git'
alias vi='vim'
alias df='df -h'
alias g='git'
alias gi='git'
alias gu='git up'
alias gl='git log'
alias gf='git fetch'
alias b='cd -'
alias cda='cd -P .'
alias cart='cat'
alias tf='terraform'

alias k=kubectl
alias kk='kubectl krew'

alias tmf='tmux loadb'

alias @lines='grep -c ""'
