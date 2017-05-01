# $HOME/.zprofile

if [ $SHLVL -gt 1 -a -d ${HOME}/.rbenv  ] ; then
    which rbenv > /dev/null && eval "$(rbenv init - zsh)"
fi

if [ $SHLVL -gt 1 -a -d ${HOME}/.pyenv ]; then
    which pyenv > /dev/null && eval "$(pyenv init -)"
fi

if [ $SHLVL -gt 1 -a -d ${HOME}/.pyenv ]; then
    eval "$(pyenv init -)"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    ssh-agent > ~/.ssh/environment
    eval $(< ~/.ssh/environment)
fi

if [ -x "$(which VBoxClient >/dev/null 2>&1)" ]; then
    VBoxClient --clipboard
fi
