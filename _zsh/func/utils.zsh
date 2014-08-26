# weechat
function tweechat {
  if [ -x `which weechat` ]; then
    if ! (ps aux | grep '[w]eechat' 2>&1 > /dev/null); then
      tmux new-window -t ${WEECHAT_TMUX_WINNUM:-98} weechat
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
    tmux last
  fi
}

function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function s() {
  ssh $(awk '
    tolower($1)=="host" {
      for (i=2; i<=NF; i++) {
        if ($i !~ "[*?]") {
          print $i
        }
      }
    }
  ' ~/.ssh/config | sort | peco)
}
