# set -Cu

RESET='\e[0m'

BLACK='\e[0;30;25m'
RED='\e[0;31;25m'
GREEN='\e[0;32;25m'
YELLOW='\e[0;33;25m'
BLUE='\e[0;34;25m'
MAGENTA='\e[0;35;25m'
CYAN='\e[0;36;25m'
WHITE='\e[0;37;25m'
BRIGHT_BLACK='\e[0;90;25m'
BRIGHT_RED='\e[0;91;25m'
BRIGHT_GREEN='\e[0;92;25m'
BRIGHT_YELLOW='\e[0;93;25m'
BRIGHT_BLUE='\e[0;94;25m'
BRIGHT_MAGENTA='\e[0;95;25m'
BRIGHT_CYAN='\e[0;96;25m'
BRIGHT_WHITE='\e[0;97;25m'

set_prompt() {
    local user=$1
    local host=$2
    local cwd=$3

    if [ "$(tput colors)" = "256" ]; then
        PS1="${user}\u${RESET}@${host}\h:${cwd}\w${RESET}"
    else
        PS1='\u@\h:\w'
    fi
    PS1="${PS1}\n$ "
}
