# ZSH envioronment
export LANG="en_US.UTF-8"
export TERM=xterm-256color
export DEFAULT_USER=$USER
export EDITOR=nvim
export PATH=$HOME/.bin:$HOME/.local/bin:/usr/local/sbin:$PATH

# Working directory
export WORKSPACE="$HOME/Workspace"
[[ `uname` != 'Darwin' ]] && export WORKSPACE="$HOME/workspace"

# Zinit
export PATH=$HOME/.zinit/polaris/bin:$PATH

# Cask
export PATH=$HOME/.cask/bin:$PATH

# Default's Apps
export EDITOR="nvim"
# export READER="zathura"
export VISUAL="nvim"
# export TERMINAL="iterm2"
# export BROWSER="brave"
# export VIDEO="mpv"
# export IMAGE="sxiv"
# export COLORTERM="truecolor"
# export OPENER="xdg-open"
# export PAGER="less"
# export WM="bspwm"


# Golang
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn # https://athens.azurefd.net
export GOPATH=$HOME/go
export PATH=${GOPATH//://bin:}/bin:$PATH

# Bat
export BAT_THEME="TwoDark"

# GOALNG
export GOPATH=$WORKSPACE/golang
export GOBIN=$GOPATH/bin
export GO111MODULE=auto
export PATH=/usr/local/go/bin:$GOBIN:$PATH
export GOPROXY=https://goproxy.cn
export GOSUMDB=off

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
export PYTHON_BUILD_MIRROR_URL="https://npm.taobao.org/mirrors/python/"

# Fzf
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border --color "border:#b877db" --preview="bat {} --color=always"'

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# GVM
export NVM_DIR="$HOME/.nvm"
