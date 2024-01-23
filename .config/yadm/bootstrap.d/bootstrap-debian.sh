#! /bin/bash

# 使用 lsb_release 命令获取发行版信息
distro=$(lsb_release -si)

declare -a cargo_install=(ripgrep fd-find exa bat hexyl zoxide difftastic)
declare -a apt_package=(curl wget fzf duf jq tldr)

# 判断发行版是否为 Ubuntu 或 Debian
if [[ $distro == "Ubuntu" ]] || [[ $distro == "Debian" ]]; then
    # Change aliyun mirror
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update -y

    # Install package
    for pkg in "${apt_package[@]}"; do
      sudo apt install -y $pkg
    done
    
    
    # Install rust
    if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
      export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
      export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      source $HOME/.cargo/env
    fi

    # Install some rust tools
    for tool in "${cargo_install[@]}"; do
      cargo install $tool
    done
fi
