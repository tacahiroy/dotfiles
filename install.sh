#!/bin/bash

UN=$(uname | tr '[:upper:]' '[:lower:]')

if [ "${UN}" = 'darwin' ]; then
	READLINK=realpath
else
	READLINK='readlink -f'
fi

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.tmux"

for y in *; do
	case $y in
		README.md|UltiSnips|osx|install.sh|tmux.conf*|tmux-powerlinerc|bin)
            continue
			;;
        config)
            XDG_CONFIG_HOME=$HOME/.config
            if [ ! -d ${XDG_CONFIG_HOME} ]; then
                mkdir ${XDG_CONFIG_HOME}
            fi
            for y in $(find config -type d -not -wholename config); do
                source=$(${READLINK} $y)
                target=${XDG_CONFIG_HOME}/$(basename $y)
                [ -L ${target} ] && unlink ${taget}
                ln -s ${source} ${target}
            done
            ;;
		*)
			source=$y
            target=$HOME/.${source}
            [ -L ${target} ] && unlink ${target}
            ln -s $(${READLINK} ${source}) ${target}
			;;
	esac
done

##
# tmux
#
echo '** Configuring tmux'

if [ "${UN}" = 'linux' ]; then
    if grep Microsoft >/dev/null 2>&1 /proc/version; then
        TMUX_CONF=${TMUX_CONF}.${UN}
    fi
fi
TMUX_CONF=tmux.conf

if tmux -V | grep 'tmux 1' >/dev/null 2>&1; then
	TMUX_CONF=${TMUX_CONF}.1
fi

echo "INFO: ${TMUX_CONF} is selected for this machine"

target=$HOME/.tmux.conf
[ -L ${target} ] && unlink ${target}
ln -s $(${READLINK} ${TMUX_CONF}) ${target}

echo Copying clipper
cp bin/clipper $HOME/bin
