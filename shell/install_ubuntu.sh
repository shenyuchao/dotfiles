#!/bin/bash

# Packages
packages=(
    build-essential
    git
    zsh

    # sudo add-apt-repository -y ppa:kelleyk/emacs
    # emacs26                     # emacs-snapshot

    # aspell                      # hunspell
    # parcellite                  # clipit
    # peek
    # screenkey

    neofetch                    # screenfetch
    tmux
    neovim

    # Quick launcher: synapse/albert/Ulauncher
    # sudo add-apt-repository ppa:agornostal/ulauncher
    # ulauncher
)

# Get OS name
SYSTEM=`uname -s`

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

function cht {
    sudo curl https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht
    sudo chmod +x /usr/local/bin/cht
    curl https://cheat.sh/:zsh > $ZINIT[COMPLETIONS_DIR]/_cht
}

function check {
    if ! command -v git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}" >&2
        exit 1
    fi

    if command -v apt >/dev/null 2>&1; then
        APT=apt
    elif command -v apt-get >/dev/null 2>&1; then
        APT=apt-get
    fi

    if [ ! "$SYSTEM" = "Linux" ] || [ -z "$APT" ]; then
        echo "${RED}Error: Not Ubuntu or its derived edition${NORMAL}" >&2
        exit 1
    fi
}

function repo {
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo $APT update -y
}

function tool {
    cht
}

function install {
    for p in ${packages[@]}; do
        printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
        sudo $APT upgrade -y ${p}
    done
}

function main {
    check
    repo
    tool
    install
}

main
