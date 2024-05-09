#!/bin/bash

# color macro
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

show_help() {
	echo -e "\nUsage: $0 [all|essential]"
	echo "    all       - Install all packages"
	echo -e "    essential - Install essential packages (Default)\n"
	exit 1
}

install_nvim() {
	if ! command -v nvim &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install Neovim${RESET}"
		wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
		tar xf nvim-linux64.tar.gz
		sudo mv nvim-linux64 /usr/local
		echo "export PATH=/usr/local/nvim-linux64/bin:$PATH" >>$HOME/.bashrc

		if [ -e "nvim-linux64.tar.gz" ]; then
			rm -rf nvim-linux64.tar.gz
		fi
	fi
}

install_python_venv() {
	if ! command -v python3 &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Cannot acquire python3 version. Installing 'python3' ...${RESET}"
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')

	if ! python3 -c "import venv" &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install python3-venv to support LSP${RESET}"
		sudo apt-get install python${python_version}-venv
	fi
}

install_bat_extra() {
	if ! command -v nvim &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'bat-extras' enhanced CLI tools${RESET}"
		git clone https://github.com/eth-p/bat-extras.git bat-extras
		sudo ./bat-extras/build.sh
		sudo mv bat-extras /usr/local
		echo "export PATH=/usr/local/bat-extras/bin:$PATH" >>$HOME/.bashrc
	fi
}

install_clang_format() {
	if ! command -v clang-format &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install clang and clang-format${RESET}"
		sudo apt-get install -y clang clang-format
	fi
}

install_lua_ls() {
	if ! command -v lua-language-server &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install lua-language-server${RESET}"
		LUA_LS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
		if -n ${LUA_LS_VERSION}; then
			curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz"
		else
			curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-3.8.3-linux-x64.tar.gz"
		fi
		# If automatically download failed, please check <https://github.com/LuaLS/lua-language-server/releases>
		mkdir -p lua_ls
		tar xf lua_ls.tar.gz -C lua_ls
		sudo mv lus_ls /usr/local
		# add lus_ls/bin into .bashrc
		echo "export PATH=/usr/local/lus_ls/bin:$PATH" >>$HOME/.bashrc
	fi
}

install_yazi() {
	if ! command -v yazi &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'yazi' to support TUI file manager${RESET}"
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		rustup update
		cargo install --locked yazi-fm yazi-cli
	fi
}

install_lazygit() {
	if ! command -v lazygit &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'lazygit' to support TUI git operations${RESET}"
		# ensure we can acquire valid lazygit version or we use the default one
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		if -n ${LAZYGIT_VERSION}; then
			curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		else
			curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_0.41.0_Linux_x86_64.tar.gz"
		fi
		tar xf lazygit.tar.gz lazygit
		sudo install lazygit /usr/local/bin

		# remove download files
		if [ -d "lazygit" ]; then
			rm -rf lazygit
		fi
		if [ -e "lazygit.tar.gz" ]; then
			rm -rf lazygit.tar.gz
		fi
	fi
}

install_nvim_config() {
	echo -e "${MAGENTA}[nvim]: Add neovim configuration files${RESET}"
	if [ ! -d "dotfiles" ]; then
		git clone https://github.com/HangX-Ma/dotfiles.git
	fi
	if [ ! -d "$HOME/.config" ]; then
		mkdir $HOME/.config
	fi
	cp -r dotfiles/nvim $HOME/.config
	if [ -d "dotfiles" ]; then
		rm -rf dotfiles
	fi
}

install_essential() {
	# install essential packages
	sudo apt-get update
	sudo apt-get install -y ninja-build cmake unzip zip curl build-essential luarocks lua5.3 npm fd-find ripgrep global sqlite3 libsqlite3-dev bat
	sudo luarocks install jsregexp

	# install lazygit
	install_lazygit
}

install_all() {
	install_nvim
	install_essential
	install_bat_extra
	install_clang_format
	install_lua_ls
	install_python_venv
	source $HOME/.bashrc

	install_nvim_config
}

main() {
	# check the input parameter number
	if [ $# -gt 1 ]; then
		echo -e "${YELLOW}[nvim]: Please enter only 1 parameter${RESET}"
		show_help
	fi

	operation="essential"

	if [ $# -eq 1 ]; then
		case $1 in
		all)
			operation="all"
			;;
		essential)
			operation="essential"
			;;
		*)
			echo -e "${YELLOW}[nvim]: Invalid parameter: '$1'${RESET}"
			show_help
			;;
		esac
	fi

	echo -e "${MAGENTA}[nvim]: Install $operation packages ...${RESET}"

	if [ "$operation" = "all" ]; then
		install_all
	elif [ "$operation" = "essential" ]; then
		install_essential
	fi

	echo -e "${GREEN}[nvim]: Done!${RESET}"
}

main "$@"
