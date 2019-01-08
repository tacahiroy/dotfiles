#!/bin/bash

set -Cue

UN=$(uname | tr '[:upper:]' '[:lower:]')

if [ "${UN}" = 'darwin' ]; then
	READLINK=realpath
else
	READLINK='readlink -f'
fi

curd=$(dirname "$(${READLINK} "$0")")
BLACKLIST="${curd}/.blacklist"

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.tmux"

for x in *; do
    grep "^${x}$" "${BLACKLIST}" && continue
	case $x in
        config)
            XDG_CONFIG_HOME=$HOME/.config
            if [ ! -d "${XDG_CONFIG_HOME}" ]; then
                mkdir "${XDG_CONFIG_HOME}"
            fi

            while read -r y; do
                source=$(${READLINK} "$y")
                target=${XDG_CONFIG_HOME}/$(basename "$y")
                [ -L "${target}" ] && unlink "${target}"
                echo ln -s "${source}" "${target}"
                ln -s "${source}" "${target}"
            done < <(find config -type d -not -wholename config)
            ;;
		*)
			source=$x
            target=$HOME/.${source}
            [ -L "${target}" ] && unlink "${target}"
            echo ln -s "$(${READLINK} "${source}")" "${target}"
            ln -s "$(${READLINK} "${source}")" "${target}"
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
echo ln -s "$(${READLINK} "${TMUX_CONF}")" "${target}"
ln -s "$(${READLINK} "${TMUX_CONF}")" "${target}"
