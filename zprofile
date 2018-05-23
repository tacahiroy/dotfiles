# $HOME/.zprofile

agent_env=$HOME/.ssh/agent.env
if [ -z "$SSH_AUTH_SOCK" ]; then
    ssh-agent > "${agent_env}"
    . "${agent_env}"
fi

if [ -x "$(which VBoxClient >/dev/null 2>&1)" ]; then
    VBoxClient --clipboard
fi

export PATH="$HOME/.cargo/bin:$PATH"
