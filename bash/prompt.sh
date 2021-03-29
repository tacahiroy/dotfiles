#!/bin/bash

RESET='\e[0m'

export BLACK='\e[0;30;25m'
export RED='\e[0;31;25m'
export GREEN='\e[0;32;25m'
export YELLOW='\e[0;33;25m'
export BLUE='\e[0;34;25m'
export MAGENTA='\e[0;35;25m'
export CYAN='\e[0;36;25m'
export WHITE='\e[0;37;25m'
export BRIGHT_BLACK='\e[0;90;25m'
export BRIGHT_RED='\e[0;91;25m'
export BRIGHT_GREEN='\e[0;92;25m'
export BRIGHT_YELLOW='\e[0;93;25m'
export BRIGHT_BLUE='\e[0;94;25m'
export BRIGHT_MAGENTA='\e[0;95;25m'
export BRIGHT_CYAN='\e[0;96;25m'
export BRIGHT_WHITE='\e[0;97;25m'

set_prompt() {
    local user=$1
    local host=$2
    local cwd=$3
    local extras=${4:-}

    if [ "$(tput colors)" = "256" ]; then
        PS1="${user}\u${RESET}@${host}\h:${cwd}\w${RESET}"
    else
        PS1='\u@\h:\w'
    fi
    PS1="${PS1}${extras}\n$ "
}
