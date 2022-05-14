#!/bin/sh
#############################################################
# dotfiles
# Author: Yuchao Shen <syc2673@gmail.com>
# URL: https://github.com/shenyuchao/dotfiles
#############################################################

# Variables
DOTFILES=$HOME/.dotfiles
NVIM=$HOME/.config/nvim
TMUX=$HOME/.tmux
ZSH=$HOME/.zinit

# Get OS informatio
OS=`uname -s`
OSREV=`uname -r`
OSARCH=`uname -m`

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

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

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"
    local repo_branch="$3"

    if [ -z "$repo_branch" ]; then
        repo_branch="master"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 --branch $repo_branch "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin $repo_branch; cd - >/dev/null
    fi
}

is_mac()
{
    [ "$OS" = "Darwin" ]
}

is_cygwin()
{
    [ `cat /etc/redhat-release` = "centos" ]
}

is_centos()
{
    command -v yum >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1
}

is_linux()
{
    [ "$OS" = "Linux" ]
}

is_debian() {
    command -v apt-get >/dev/null 2>&1
}

is_arch() {
    command -v yay >/dev/null 2>&1 || command -v pacman >/dev/null 2>&1
}

install_package() {
    if ! command -v ${1} >/dev/null 2>&1; then
        if is_mac; then
            brew install ${1}
        elif is_debian; then
            sudo apt-get install -y ${1}
        elif is_arch; then
            pacman -Ssu --noconfirm ${1}
        elif is_cygwin; then
            apt-cyg install -y ${1}
        elif is_centos; then
            yum install -y ${1}
        fi
    else
        if is_mac; then
            brew upgrade ${1}
        elif is_debian; then
            sudo apt-get upgrade -y ${1}
        elif is_arch; then
            pacman -Ssu --noconfirm ${1}
        elif is_cygwin; then
            apt-cyg upgrade -y ${1}
        elif is_centos; then
            yum upgrade -y ${1}
        fi
    fi
}

# Clean all configurations
clean_dotfiles() {
    confs="
    .gemrc
    .gitconfig
    .markdownlintrc
    .npmrc
    .tmux.conf
    .vimrc
    .zshenv
    .zshrc
    .zshrc.local
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    [ -d $NVIM ] && mv $NVIM $NVIM.bak

    rm -rf $ZSH $TMUX $DOTFILES

    rm -f $HOME/.gitignore_global $HOME/.gitconfig_global
    rm -f $HOME/.tmux.conf $HOME/.tmux.local
    touch $HOME/.zshrc # ignore zinit error: not found .zshrc
}

YES=0
NO=1
promote_yn() {
    eval ${2}=$NO
    read -p "$1 [y/N]: " yn
    case $yn in
        [Yy]* )    eval ${2}=$YES;;
        [Nn]*|'' ) eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

# Install Brew/apt-cyg
if is_mac && ! command -v brew >/dev/null 2>&1; then
    printf "${GREEN}▓▒░ Installing Homebrew...${NORMAL}\n"
    # Install homebrew
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Homebrew/install@HEAD/install.sh)"

    # Tap cask and cask-upgrade
    brew tap homebrew/cask
    brew tap homebrew/cask-versions
    brew tap homebrew/cask-fonts
    brew tap buo/cask-upgrade

    # Install GNU utilities
    brew install coreutils
elif is_cygwin && ! command -v apt-cyg >/dev/null 2>&1; then
    printf "${GREEN}▓▒░ Installing Apt-Cyg...${NORMAL}\n"
    APT_CYG=/usr/local/bin/apt-cyg
    curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > $APT_CYG
    chmod +x $APT_CYG
fi

# Check git
if ! command -v git >/dev/null 2>&1; then
    install_package git
fi

# Check curl
if ! command -v curl >/dev/null 2>&1; then
    install_package curl
fi

# Check zsh
if ! command -v zsh >/dev/null 2>&1; then
    install_package zsh
fi

if is_mac && ! command -v tree >/dev/null 2>&1; then
    install_package tree
fi

# ZSH plugin manager
printf "${GREEN}▓▒░ Installing Zinit...${NORMAL}\n"
if ! command -v zinit >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
else
    zinit self-update
fi

# Reset configurations
if [ -d $ZSH ] || [ -d $TMUX ] || [ -d $NVIM ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Dotfiles
printf "${GREEN}▓▒░ Installing Dotfiles...${NORMAL}\n"
sync_repo shenyuchao/dotfiles $DOTFILES main

chmod +x $DOTFILES/install.sh
# chmod +x $DOTFILES/install_brew_cask.sh
# chmod +x $DOTFILES/install_go.sh

ln -sf $DOTFILES/zsh/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/zsh/.zshrc.local $HOME/.zshrc.local
ln -sf $DOTFILES/zsh/.p10k.zsh $HOME/.p10k.zsh
ln -sf $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/tmux/.tmux.conf.local $HOME/.tmux.conf.local
ln -sf $DOTFILES/.markdownlintrc $HOME/.markdownlintrc

ln -sf $DOTFILES/node/.npmrc $HOME/.npmrc
ln -sf $DOTFILES/ruby/.gemrc $HOME/.gemrc
mkdir -p $HOME/.cargo && cp -n $DOTFILES/rust/cargo.config $HOME/.cargo/config
mkdir -p $HOME/.pip; cp -n $DOTFILES/python/.pip.conf $HOME/.pip/pip.conf

cp -n $DOTFILES/git/.gitconfig $HOME/.gitconfig
cp -n $DOTFILES/git/.gitignore $HOME/.gitignore

# NVIM Configs
printf "${GREEN}▓▒░ Installing NVIM Nvchad...${NORMAL}\n"
sync_repo NvChad/NvChad $NVIM main
ln -sf $DOTFILES/vim/nvchad/custom $NVIM/lua/custom
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Oh My Tmux
printf "${GREEN}▓▒░ Installing Oh My Tmux...${NORMAL}\n"
sync_repo gpakosz/.tmux $TMUX
ln -sf $TMUX/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/tmux/.tmux.conf.local $HOME/.tmux.conf.local

# Entering zsh
printf "Done. Enjoy!\n"
if command -v zsh >/dev/null 2>&1; then
    if [ "$OSTYPE" != "cygwin" ] && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        printf "${GREEN} You need to logout and login to enable zsh as the default shell.${NORMAL}\n"
    fi
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}" >&2
    exit 1
fi
