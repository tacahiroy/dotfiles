#!/bin/bash

for y in *; do
	case $y in
		README.md|UltiSnips|osx|install.sh|tmux.conf*|tmux-powerlinerc)
			;;
		*)
			source=$y
			;;
	esac

	target=$HOME/.${source}

	[ -L ${target} ] && unlink ${target}
	ln -s $(readlink -f ${source}) ${target}
done

U=$(uname | tr '[A-Z]' '[a-z]')
if [ "${U}" = 'linux' ]; then
    if cat /proc/version | grep Microsoft 2>&1 >/dev/null; then
        U=bow
    fi
fi
TMUX_CONF=tmux.conf

if tmux -V | grep 'tmux 1'; then
	TMUX_CONF=${TMUX_CONF}.1
fi
TMUX_CONF=${TMUX_CONF}.${U}

target=$HOME/.tmux.conf
[ -L ${target} ] && unlink ${target}
ln -s $(readlink -f ${TMUX_CONF}) ${target}
