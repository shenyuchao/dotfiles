#!/bin/bash
#############################################################
# Install packages for Debian or its derived editions (e.g. Ubuntu, Mint).
# Support Ubuntu 24.04+
# Author: Yuchao Shen <syc2673@gmail.com>
# URL: https://github.com/shenyuchao/dotfiles
#############################################################

# Packages
packages=(
  # prerequisite
  build-essential
  
  # modern tools
  bat
  btm
  btop
  duf
  # dust
  eza # exa
  fd-find
  fzf
  git-delta
  tig # gitui
  gping
  hyperfine
  neofetch
  # procs
  ripgrep
  # sd
  # tealdeer
  zoxide

  # sudo add-apt-repository -y ppa:kelleyk/emacs
  # emacs                       # emacs-snapshot

  aspell # hunspell
  # parcellite                  # clipit
  # peek
  # screenkey

  # Quick launcher: synapse/albert/Ulauncher
  # sudo add-apt-repository ppa:agornostal/ulauncher
  # ulauncher
)

# Get OS name
SYSTEM=$(uname -s)

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
    echo "${RED}Error: Not Debian or its derived edition${NORMAL}" >&2
    exit 1
  fi
}

function install {
  for p in ${packages[@]}; do
    printf "${BLUE} ➜  Installing ${p}...${NORMAL}\n"
    sudo $APT upgrade -y ${p}
  done
  install_asdf
}

function install_asdf {
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)

  if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
  elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
  else
  echo "❌ Unsupported architecture: $ARCH"
  exit 1
  fi

  VERSION="v0.16.0"
  ASDF_URL="https://github.com/asdf-vm/asdf/releases/download/${VERSION}/asdf-${VERSION}-${OS}-${ARCH}.tar.gz"
  INSTALL_DIR="$HOME/.local/bin"
  ASDF_BIN="$INSTALL_DIR/asdf"
  echo $ASDF_URL

  # 2. 创建安装目录并下载 asdf
  mkdir -p "$INSTALL_DIR"
  curl -Lo "$ASDF_BIN" "$ASDF_URL"
  tar -C $INSTALL_DIR -zxf $ASDF_BIN
  chmod +x "$ASDF_BIN"

  echo "✅ asdf $VERSION installed to $ASDF_BIN"
}

function main {
  check
  install
}

main
