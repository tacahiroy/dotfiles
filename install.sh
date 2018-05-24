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
		README.md|osx|install.sh|tmux.conf*|bin)
            continue
			;;
        config)
            XDG_CONFIG_HOME=$HOME/.config
            if [ ! -d "${XDG_CONFIG_HOME}" ]; then
                mkdir "${XDG_CONFIG_HOME}"
            fi
            for y in $(find config -type d -not -wholename config); do
                source=$(${READLINK} "$y")
                target=${XDG_CONFIG_HOME}/$(basename "$y")
                [ -L "${target}" ] && unlink "${target}"
                ln -s "${source}" "${target}"
            done
            ;;
		*)
			source=$y
            target=$HOME/.${source}
            [ -L "${target}" ] && unlink "${target}"
            ln -s $(${READLINK} "${source}") "${target}"
			;;
	esac
done

##
# tmux
#
echo '** Configuring tmux'

TMUX_CONF=tmux.conf
echo "INFO: ${TMUX_CONF} is selected for this machine"

target=$HOME/.tmux.conf
[ -L "${target}" ] && unlink "${target}"
ln -s $(${READLINK} ${TMUX_CONF}) "${target}"
