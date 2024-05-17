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
	echo -e "\nUsage: $0 [all|basic|component|help]"
	echo "    all       - Install all packages"
	echo "    basic     - Install basic component to support nvim functions(Default)"
	echo "    component - Install component that you need"
	echo -e "    help      - Show this usage guidance information\n"
	exit 1
}

show_components() {
	echo -e "${MAGENTA}[nvim]: Select component that you want to install:${RESET}"
	echo -e "    1) neovim"
	echo -e "    2) lazygit"
	echo -e "    3) yazi"
	echo -e "    4) bat-extras"
	echo -e "    5) clang-format"
	echo -e "    6) lua_ls"
	echo -e "    7) python3-venv"
	echo -e "    8) python-repl"
	echo -e "    9) nvim-config"
}

install_nvim() {
	if ! command -v nvim &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install Neovim${RESET}"
		wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
		tar xf nvim-linux64.tar.gz
		sudo mv nvim-linux64 /usr/local
		echo 'export PATH="/usr/local/nvim-linux64/bin:$PATH"' >>$HOME/.bashrc

		if [ -e "nvim-linux64.tar.gz" ]; then
			rm -rf nvim-linux64.tar.gz
		fi
	fi
}

install_lazygit() {
	if ! command -v lazygit &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'lazygit' to support TUI git operations${RESET}"
		# ensure we can acquire valid lazygit version or we use the default one
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		if [ -z "${LAZYGIT_VERSION}" ]; then
			LAZYGIT_VERSION="0.41.0"
		fi
		echo -e "${GREEN}[nvim]: lazygit version: ${RESET}"
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		sudo mv lazygit /usr/local/bin
	fi
	# remove download files
	if [ -e "lazygit" ]; then
		rm -rf lazygit
	fi
	if [ -e "lazygit.tar.gz" ]; then
		rm -rf lazygit.tar.gz
	fi
}

install_yazi() {
	if ! command -v yazi &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'yazi' to support TUI file manager${RESET}"
		if ! command -v rustup; then
			curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
			echo '. "$HOME/.cargo/env"' >>$HOME/.bashrc
		fi
		source $HOME/.cargo/env
		rustup update
		cargo install --locked yazi-fm yazi-cli
	fi
}

install_bat_extra() {
	if ! command -v batgrep &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install 'bat-extras' enhanced CLI tools${RESET}"
		sudo apt-get install -y gawk
		# install 'shfmt'
		curl -sS https://webinstall.dev/shfmt | bash
		source "~/.config/envman/PATH.env"
		git clone https://github.com/eth-p/bat-extras.git bat-extras
		sudo ./bat-extras/build.sh --install
		if [ -d "bat-extras" ]; then
			rm -rf bat-extras
		fi
		echo 'export PATH="/usr/local/bat-extras/bin:$PATH"' >>$HOME/.bashrc
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
		if [ ! -e "lua_ls.tar.gz" ]; then
			LUA_LS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
			if [ -z "${LUA_LS_VERSION}" ]; then
				LUA_LS_VERSION="3.8.3"
			fi
			# If automatically download failed, please check <https://github.com/LuaLS/lua-language-server/releases>
			echo -e "${GREEN}[nvim]: lua_ls version: ${LUA_LS_VERSION}${RESET}"
			curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz"
		fi

		# check download file
		file_type=$(file "lua_ls.tar.gz")
		if [[ "$file_type" == *tar* ]]; then
			mkdir -p lua_ls
			if [ -d "lua_ls" ]; then
				tar xf lua_ls.tar.gz -C lua_ls
				if [ -d "/usr/local/lua_ls" ]; then
					sudo rm -rf /usr/local/lua_ls
				fi
				sudo mv lua_ls /usr/local/
			fi
			# add lua_ls/bin into .bashrc
			if [ -d "/usr/local/lua_ls/bin" ]; then
				echo 'export PATH="/usr/local/lua_ls/bin:$PATH"' >>$HOME/.bashrc
			else
				echo -e "${YELLOW}[nvim]: /usr/local/lua_ls/bin directory not found${RESET}"
			fi
		else
			echo -e "${YELLOW}[nvim]: lua_ls.tar.gz filetype is not 'tar'${RESET}"
		fi

	fi
}

install_python3_venv() {
	if ! command -v python3 &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Cannot acquire python3 version. Installing 'python3' ...${RESET}"
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')

	# check the minimum requirement python version
	if (($(echo "${python_version} < 3.3" | bc -l))); then
		echo -e "${YELLOW}[nvim]: Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		exit 1
	fi

	# no output means the module has been installed
	if ! python3 -c "import venv" &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Install python3-venv to support LSP${RESET}"
		sudo apt-get install -y python${python_version}-venv
	fi
}

install_repl() {
	echo -e "${MAGENTA}[nvim]: Install REPL related modules${RESET}"

	# ensure python3 has been installed
	if ! command -v python3 &>/dev/null; then
		sudo apt-get install -y python3 python3-dev
	fi

	# pynvim
	if ! python3 -m pip list | grep pynvim &>/dev/null; then
		python3 -m pip install pynvim
	fi

	# jupyter
	if ! python3 -m pip list | grep jupyter &>/dev/null; then
		python3 -m pip install jupyter
	fi

	# jupytext
	if ! python3 -m pip list | grep jupytext &>/dev/null; then
		python3 -m pip install jupytext
	fi

	# ilua
	if ! python3 -m pip list | grep ilua &>/dev/null; then
		python3 -m pip install ilua
	fi
}

install_nvim_config() {
	echo -e "${MAGENTA}[nvim]: Update neovim configuration files${RESET}"
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

select_component() {
	read choice
	if [[ $choice =~ ^[1-9]$ ]]; then
		case $choice in
		1)
			install_nvim
			;;
		2)
			install_lazygit
			;;
		3)
			install_yazi
			;;
		4)
			install_bat_extra
			;;
		5)
			install_clang_format
			;;
		6)
			install_lua_ls
			;;
		7)
			install_python3_venv
			;;
		8)
			install_repl
			;;
		9)
			install_nvim_config
			;;
		esac
	else
		echo -e "${YELLOW}Invalid input. Please enter a number between 1 and 9.${RESET}"
		exit 1
	fi
}

install_essential() {
	# install essential packages
	sudo apt-get install -y ninja-build cmake unzip zip curl build-essential luarocks lua5.3 liblua5.3-dev npm fd-find ripgrep global sqlite3 libsqlite3-dev bat
	if command -v luarocks &>/dev/null; then
		if ! luarocks list | grep jsregexp &>/dev/null; then
			sudo luarocks install jsregexp
		fi
	fi
}

install_all() {
	# packages
	install_nvim
	install_essential
	install_yazi
	install_lazygit
	install_bat_extra
	install_clang_format
	install_lua_ls
	install_python3_venv
	install_repl
}

main() {
	# check the input parameter number
	if [ $# -gt 1 ]; then
		echo -e "${YELLOW}[nvim]: Please enter only 1 parameter${RESET}"
		show_help
	fi

	operation="basic"

	if [ $# -eq 1 ]; then
		case $1 in
		all)
			operation="all"
			;;
		basic)
			operation="basic"
			;;
		component)
			operation="component"
			;;
		help)
			show_help
			exit 1
			;;
		*)
			echo -e "${YELLOW}[nvim]: Invalid parameter: '$1'${RESET}"
			show_help
			exit 1
			;;
		esac
	fi

	if [ "$operation" != "component" ]; then
		echo -e "${MAGENTA}[nvim]: Install $operation packages ...${RESET}"
	fi

	sudo apt-get update
	if [ "$operation" = "all" ]; then
		install_all
		install_nvim_config
	elif [ "$operation" = "basic" ]; then
		install_nvim
		install_essential
		install_nvim_config
	elif [ "$operation" = "component" ]; then
		show_components
		select_component
	fi
	source $HOME/.bashrc

	echo -e "${GREEN}[nvim]: Done!${RESET}"
}

main "$@"
