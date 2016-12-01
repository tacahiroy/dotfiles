#!/bin/bash

UN=$(uname | tr '[A-Z]' '[a-z]')

if [ "${UN}" = 'darwin' ]; then
	READLINK=realpath
else
	READLINK='readlink -f'
fi

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
	ln -s $(${READLINK} ${source}) ${target}
done

if [ "${UN}" = 'linux' ]; then
    if cat /proc/version | grep Microsoft 2>&1 >/dev/null; then
        U=bow
    fi
fi
TMUX_CONF=tmux.conf

if tmux -V | grep 'tmux 1' 2>&1 >/dev/null; then
	TMUX_CONF=${TMUX_CONF}.1
fi
TMUX_CONF=${TMUX_CONF}.${UN}

target=$HOME/.tmux.conf
[ -L ${target} ] && unlink ${target}
ln -s $(${READLINK} ${TMUX_CONF}) ${target}
