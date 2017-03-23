# $HOME/.zprofile

if [ $SHLVL -gt 1 -a -d ${HOME}/.rbenv  ] ; then
  if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    ssh-agent > ~/.ssh/environment
    eval $(< ~/.ssh/environment)
fi

if [ -x "$(which VBoxClient >/dev/null 2>&1)" ]; then
    VBoxClient --clipboard
fi
