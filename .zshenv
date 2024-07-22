# ZSH envioronment
export LANG="en_US.UTF-8"
export TERM=xterm-256color
export DEFAULT_USER=$USER
export EDITOR=nvim

export PATH=$HOME/.bin:$HOME/.local/bin:/usr/local/sbin:$PATH

# Working directory
export WORKSPACE="$HOME/Workspace"
[[ `uname` != 'Darwin' ]] && export WORKSPACE="$HOME/workspace"

# Default's Apps
export EDITOR="nvim"
export VISUAL="nvim"

# Golang
export GO111MODULE=on
export GOPROXY=https://goproxy.cn 
export GOPATH=$WORKSPACE/golang
export PATH=$GOPATH/bin:$PATH

# Pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
export PYTHON_BUILD_MIRROR_URL="https://npm.taobao.org/mirrors/python/"

# Rust
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
[[ -f "$HOME/.cargo/env" ]] && source $HOME/.cargo/env

# composer
export COMPOSER_MEMORY_LIMIT=-1

# BREW
export HOMEBREW_NO_AUTO_UPDATE=true

# ANSIBLE
export ANSIBLE_INVENTORY=$HOME/.ansible/hosts
export XDG_DATA_HOME=$HOME/.local/share

# fnm
export FNM_DIR="$HOME/.local/share/fnm"
. "$HOME/.cargo/env"
