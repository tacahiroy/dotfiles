#!/bin/bash

set -Cue

READLINK=realpath

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
                echo ln -sf "${source}" "${target}"
                ln -sf "${source}" "${target}"
            done < <(find config -type d -not -wholename config)
            ;;
		*)
			source=$x
            target=$HOME/.${source}
            [ -L "${target}" ] && unlink "${target}"
            echo ln -sf "$(${READLINK} "${source}")" "${target}"
            ln -sf "$(${READLINK} "${source}")" "${target}"
			;;
	esac
done
