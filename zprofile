# $HOME/.zprofile

if [ $SHLVL -gt 1 -a -d ${HOME}/.rbenv  ] ; then
  if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
fi

source $(brew --prefix dnvm)/bin/dnvm.sh

# For Mono/ASP.NET 5
export MONO_GAC_PREFIX="/usr/local"
source dnvm.sh
export MONO_MANAGED_WATCHER=false
