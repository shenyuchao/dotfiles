#! /bin/bash

# 使用 lsb_release 命令获取发行版信息
distro=$(lsb_release -si)

declare -a cargo_install=(ripgrep fd-find exa bat hexyl zoxide difftastic)
declare -a apt_package=(build-essential curl wget neovim git fzf duf jq tldr zsh)

# 判断发行版是否为 Ubuntu 或 Debian
if [[ $distro == "Ubuntu" ]] || [[ $distro == "Debian" ]]; then
	# Change aliyun mirror
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
	sudo apt update -y
	sudo apt-get install software-properties-common
	sudo add-apt-repository ppa:neovim-ppa/unstable -y

	# Install apt package
	for pkg in "${apt_package[@]}"; do
		sudo apt install -y $pkg
	done

	install_third_package

	sudo chsh -s /usr/bin/zsh

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

install_third_package() {
	# install startship
	curl -sS https://starship.rs/install.sh | sh

	# Install lazygit
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	rm -rf lazygit.tar.gz
}
