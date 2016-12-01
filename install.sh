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
			;;
		*)
			source=$y
			;;
	esac

	target=$HOME/.${source}

	[ -L ${target} ] && unlink ${target}
    ln -s $(${READLINK} ${source}) ${target}
done
exit

##
# tmux
#
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

cp bin/clipper $HOME/bin

##
# vim-plug
#
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
  curl -s https://raw.githubusercontent.com/getantibody/homebrew-antibody/master/antibody.rb |
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
    echo Installing antibody
    test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"
    download
    extract || true
    mv -f "$TMPDIR"/antibody $HOME/bin
    which antibody
    echo Done
fi
