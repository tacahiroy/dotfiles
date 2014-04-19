# weechat
function tweechat {
  if [ -x `which weechat-curses` ]; then
    if ! (ps aux | grep '[w]eechat-curses' 2>&1 > /dev/null); then
      tmux new-window -t ${WEECHAT_TMUX_WINNUM:-98} weechat-curses
    fi
  fi
}

function tssh_tunnel() {
  srv=${1:-${SS_SRV}}

  if tmux list-windows -F '#I:#W' | grep "^99:${srv}.tnl" 2>&1 >/dev/null; then
    echo listening port ${SS_PORT}
    return
  fi

  if [ -x `which autossh` ]; then
    autossh -M 18103 -f -C2qTnN -D ${SS_PORT} ${SS_USER}@${srv} ping -i 20 localhost
  else
    tmux neww -k -n ${srv}.tnl -t 99 "ssh -C2qTnN -D ${SS_PORT} ${SS_USER}@${srv}"
  fi
  tmux last
}

