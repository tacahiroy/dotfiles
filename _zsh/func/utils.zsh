# weechat
function weechat {
  if [ -x `which weechat-curses` ]; then
    if ! (ps aux | grep '[w]eechat-curses' 2>&1 > /dev/null); then
      tmux new-window -t 9 weechat-curses
    fi
  fi
}

function tssh_tunnel() {
  if tmux list-windows -F '#I:#W' | grep '^99:jp-3.tnl' 2>&1 >/dev/null; then
    echo already listening port 8103
    return
  fi
  tmux neww -k -n jp-3.tnl -t 99 'ssh -C2qTnN -D 8103 takahiro@jp-3'
  tmux select-window -l
}

