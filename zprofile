# $HOME/.zprofile

if [ $SHLVL -gt 1 -a -d ${HOME}/.rbenv  ] ; then
    which rbenv > /dev/null && eval "$(rbenv init - zsh)"
fi

if [ $SHLVL -gt 1 -a -d ${HOME}/.pyenv ]; then
    eval "$(pyenv init - zsh)"
fi

agent_env=$HOME/.ssh/agent.env
if [ -z "$SSH_AUTH_SOCK" ]; then
    ssh-agent > "${agent_env}"
    . "${agent_env}"
fi

if [ -x "$(which VBoxClient >/dev/null 2>&1)" ]; then
    VBoxClient --clipboard
fi
