#!/bin/bash

UN=$(uname | tr '[A-Z]' '[a-z]')

if [ "${UN}" = 'darwin' ]; then
	READLINK=realpath
else
	READLINK='readlink -f'
fi

mkdir -p $HOME/bin

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
    if cat /proc/version | grep Microsoft 2>&1 >/dev/null; then
        TMUX_CONF=${TMUX_CONF}.${UN}
    fi
fi
TMUX_CONF=tmux.conf

if tmux -V | grep 'tmux 1' 2>&1 >/dev/null; then
	TMUX_CONF=${TMUX_CONF}.1
fi

echo "INFO: ${TMUX_CONF} is selected for this machine"

target=$HOME/.tmux.conf
[ -L ${target} ] && unlink ${target}
ln -s $(${READLINK} ${TMUX_CONF}) ${target}

echo Copying clipper
cp bin/clipper $HOME/bin

##
# vim-plug
#
echo '** Installing vim-plug'
PLUG_VIM=$HOME/.vim/autoload/plug.vim
if [ ! -r "${PLUG_VIM}" ]; then
    curl -fLo ${PLUG_VIM} --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

##
# Antibody
#
DOWNLOAD_URL="https://github.com/getantibody/antibody/releases/download"

last_version() {
  curl -s https://git.io/antibody |
    grep version |
    cut -f2 -d '"'
}

download() {
  version="$(last_version)" || true
  test -z "$version" && {
    echo "Unable to get antibody version."
    exit 1
  }
  echo "Downloading antibody $version for $(uname -s)_$(uname -m)..."
  rm -f /tmp/antibody.tar.gz
  curl -s -L -o /tmp/antibody.tar.gz \
    "$DOWNLOAD_URL/v$version/antibody_$(uname -s)_$(uname -m).tar.gz"
}

extract() {
  tar -xf /tmp/antibody.tar.gz -C "$TMPDIR"
}

if [ ! -x $HOME/bin/antibody ]; then
    echo '** Installing antibody'
    test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"
    download
    extract || true
    mv -f "$TMPDIR"/antibody $HOME/bin
    which antibody
    echo Done
fi
