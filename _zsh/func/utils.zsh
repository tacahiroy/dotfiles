# weechat
function weechat {
  if [ -x `which weechat-curses` ]; then
    if ! (ps aux | grep '[w]eechat-curses' 2>&1 > /dev/null); then
      tmux new-window -t 9 weechat-curses
    fi
  fi
}

## utils
function tm_conn2srvs {
  local SSH=/usr/bin/ssh
  local MOS=$HOME/bin/mos
  local SSH_CONFIG=$HOME/.ssh/config
  local pat=$1
  NODES=($(cat $HOME/bin/nodes.txt))
  if [ -z "${pat}" ]; then
    echo 'Usage: tm_conn2srvs PATTERN'
    return
  fi

  servers=($(echo ${NODES} | tr ' ' '\n' | grep "${pat}"))

  for server in ${servers[@]}; do
    if ! tmux list-windows | grep ${server}; then
      if grep -q "^Host ${server}m$" ${SSH_CONFIG}; then
        # echo mosh
        tmux new-window -n ${server} "${MOS} ${server}"
      else
        # echo ssh
        tmux new-window -n ${server} "${SSH} ${server}"
      fi
    fi
  done
}

