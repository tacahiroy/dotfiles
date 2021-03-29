if alias vim >/dev/null 2>&1; then
	unalias vim
fi

alias ls='ls -F --color=auto'
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
alias b='cd -'
alias cda='cd -P .'
alias wipython='workon ipython && ipython'
alias wansible='workon ansible'

if type _z >/dev/null 2>&1; then
    alias jc='_z -c'
fi
