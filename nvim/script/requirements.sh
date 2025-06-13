#!/bin/bash

# Color macros
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

# Default installation path
DEFAULT_PATH="/usr/local"
# Default architecture
ARCH="x86"

show_help() {
	echo -e "\nUsage: $0 [all|basic|component|help] [options]"
	echo "Operations:"
	echo "    all       - Install all packages"
	echo "    basic     - Install basic component to support nvim functions"
	echo "    component - Install component that you need"
	echo "    help      - Show this usage guidance information"
	echo -e "\nOptions:"
	echo "    --prefix=PATH   - Specify installation path (default: /usr/local)"
	echo -e "    --arch=ARCH     - Specify architecture (x86 or ARM64, default: x86)\n"
	echo "Examples:"
	echo "    $0 all --prefix=/opt --arch=ARM64"
	echo "    $0 basic --prefix=\$HOME/local"
	echo -e "    $0 component --arch=ARM64\n"
	exit 1
}

show_components() {
	echo -e "${MAGENTA}[nvim]: Select component that you want to install (ARCH=${ARCH}):${RESET}"
	echo -e "    1) neovim"
	echo -e "    2) lazygit"
	echo -e "    3) yazi"
	echo -e "    4) bat-extras"
	echo -e "    5) clang-tools"
	echo -e "    6) lua_ls"
	echo -e "    7) python3-venv"
	echo -e "    8) debug-tools"
	echo -e "    9) nvim-config"
}

verify_installation() {
	local tool=$1
	local command=$2
	if command -v $command &>/dev/null; then
		echo -e "${GREEN}[SUCCESS] $tool installed successfully${RESET}"
		return 0
	else
		echo -e "${RED}[ERROR] $tool installation failed${RESET}"
		return 1
	fi
}

install_nvim() {
	if command -v nvim &>/dev/null; then
		echo -e "${YELLOW}[nvim]: Neovim is already installed${RESET}"
		return
	fi

	echo -e "${MAGENTA}[nvim]: Installing Neovim to ${DEFAULT_PATH} (ARCH=${ARCH})${RESET}"
	local PACKAGE_NAME=""
	if [ "$ARCH" = "ARM64" ]; then
		PACKAGE_NAME="arm64"
	else
		PACKAGE_NAME="x86_64"
	fi

	if ! wget -q https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${PACKAGE_NAME}.tar.gz; then
		echo -e "${RED}[ERROR] Failed to download Neovim${RESET}"
		return 1
	fi

	tar xf nvim-linux-${PACKAGE_NAME}.tar.gz
	sudo mv nvim-linux-${PACKAGE_NAME} ${DEFAULT_PATH}
	echo "export PATH=\"${DEFAULT_PATH}/nvim-linux-${PACKAGE_NAME}/bin:\$PATH\"" >>$HOME/.bashrc
	rm -f nvim-linux-${PACKAGE_NAME}.tar.gz

	verify_installation "Neovim" "nvim"
}

install_lazygit() {
	if command -v lazygit &>/dev/null; then
		echo -e "${YELLOW}[nvim]: Lazygit is already installed${RESET}"
		return
	fi

	echo -e "${MAGENTA}[nvim]: Installing 'lazygit' to ${DEFAULT_PATH}/bin (ARCH=${ARCH})${RESET}"
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	LAZYGIT_VERSION=${LAZYGIT_VERSION:-"0.52.0"}

	if [ "$ARCH" = "ARM64" ]; then
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
	else
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	fi

	tar xf lazygit.tar.gz lazygit
	sudo mv lazygit ${DEFAULT_PATH}/bin
	rm -f lazygit.tar.gz

	verify_installation "Lazygit" "lazygit"
}

install_yazi() {
	if command -v yazi &>/dev/null; then
		echo -e "${YELLOW}[nvim]: Yazi is already installed${RESET}"
		return
	fi

	echo -e "${MAGENTA}[nvim]: Installing 'yazi' TUI file manager${RESET}"
	if ! command -v rustup &>/dev/null; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
		echo '. "$HOME/.cargo/env"' >>$HOME/.bashrc
	fi
	source $HOME/.cargo/env
	rustup update
	cargo install --locked yazi-fm yazi-cli

	verify_installation "Yazi" "yazi"
}

install_bat_extra() {
	if command -v batgrep &>/dev/null; then
		echo -e "${YELLOW}[nvim]: bat-extras is already installed${RESET}"
		return
	fi

	echo -e "${MAGENTA}[nvim]: Installing 'bat-extras' enhanced CLI tools${RESET}"
	sudo apt-get install -y gawk
	curl -sS https://webinstall.dev/shfmt | bash
	source "$HOME/.config/envman/PATH.env"

	git clone https://github.com/eth-p/bat-extras.git bat-extras
	sudo ./bat-extras/build.sh --install --prefix=${DEFAULT_PATH}
	[ -d "bat-extras" ] && sudo rm -rf bat-extras
	echo "export PATH=\"${DEFAULT_PATH}/bat-extras/bin:\$PATH\"" >>$HOME/.bashrc

	verify_installation "bat-extras" "batgrep"
}

install_clang_tools() {
	if command -v clang-format &>/dev/null; then
		echo -e "${YELLOW}[nvim]: clang-tools are already installed${RESET}"
		return
	fi

	local version="17"
	local arch=""

	case "$ARCH" in
	x86_64) arch="amd64" ;;
	aarch64) arch="arm64" ;;
	*)
		echo "Unsupported architecture: $ARCH"
		return 1
		;;
	esac

	echo -e "${MAGENTA}[nvim]: Installing clang-tools (clangd, clang-format, LLVM) version $version${RESET}"

	local temp_dir=$(mktemp -d)
	cd "$temp_dir" || return 1

	local package_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-$version.0.0/clang+llvm-$version.0.0-$ARCH-linux-gnu.tar.xz"

	echo "Downloading LLVM tools..."
	if ! wget -q "$package_url"; then
		echo -e "${RED}[ERROR] Failed to download LLVM tools${RESET}"
		return 1
	fi

	local package_file="clang+llvm-$version.0.0-$ARCH-linux-gnu.tar.xz"
	echo "Extracting $package_file..."
	tar -xf "$package_file" || {
		echo -e "${RED}[ERROR] Failed to extract package${RESET}"
		return 1
	}

	echo "Installing clang-tools to /usr/local..."
	sudo cp -r "clang+llvm-$version.0.0-$ARCH-linux-gnu"/* /usr/local/ || {
		echo -e "${RED}[ERROR] Failed to install clang-tools${RESET}"
		return 1
	}

	cd - >/dev/null
	rm -rf "$temp_dir"

	echo -e "${GREEN}[SUCCESS] Clang tools installed successfully${RESET}"
	echo "clangd version: $(clangd --version)"
	echo "clang-format version: $(clang-format --version)"
	echo "clang version: $(clang --version | head -n 1)"
}

install_lua_ls() {
	if command -v lua-language-server &>/dev/null; then
		echo -e "${YELLOW}[nvim]: lua-language-server is already installed${RESET}"
		return
	fi

	echo -e "${MAGENTA}[nvim]: Installing lua-language-server (ARCH=${ARCH})${RESET}"
	LUA_LS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
	LUA_LS_VERSION=${LUA_LS_VERSION:-"3.8.3"}

	if [ "$ARCH" = "ARM64" ]; then
		curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-arm64.tar.gz"
	else
		curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz"
	fi

	mkdir -p lua_ls
	tar xf lua_ls.tar.gz -C lua_ls
	sudo mv lua_ls ${DEFAULT_PATH}/
	echo "export PATH=\"${DEFAULT_PATH}/lua_ls/bin:\$PATH\"" >>$HOME/.bashrc
	rm -f lua_ls.tar.gz

	verify_installation "lua-language-server" "lua-language-server"
}

install_python3_venv() {
	if ! command -v python3 &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Installing Python 3${RESET}"
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo ${python_version} | cut -d. -f2)

	if (($(echo "${cut_version} < 3" | bc -l))); then
		echo -e "${RED}[ERROR] Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		return 1
	fi

	if ! python3 -c "import venv" &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Installing python3-venv${RESET}"
		sudo apt-get install -y python${python_version}-venv
	fi

	echo -e "${GREEN}[SUCCESS] Python venv is ready (Python ${python_version})${RESET}"
}

install_debug_tools() {
	echo -e "${MAGENTA}[nvim]: Installing debug tools${RESET}"

	if ! command -v python3 &>/dev/null; then
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo ${python_version} | cut -d. -f2)

	if (($(echo "${cut_version} < 3.3" | bc -l))); then
		echo -e "${RED}[ERROR] Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		return 1
	fi

	if ! python3 -c "import debugpy" &>/dev/null; then
		sudo apt-get install -y python3-debugpy
	fi

	echo -e "${GREEN}[SUCCESS] Debug tools installed${RESET}"
}

install_nvim_config() {
	echo -e "${MAGENTA}[nvim]: Update neovim configuration files? (y/n)${RESET}"
	read update_config

	if [[ $update_config != 'n' && $update_config != 'N' ]]; then
		echo -e "${MAGENTA}[nvim]: Installing nvim configuration${RESET}"
		if [ ! -d "dotfiles" ]; then
			git clone https://github.com/HangX-Ma/dotfiles.git
		fi
		[ ! -d "$HOME/.config" ] && mkdir -p $HOME/.config
		cp -r dotfiles/nvim $HOME/.config
		[ -d "dotfiles" ] && rm -rf dotfiles
		echo -e "${GREEN}[SUCCESS] Nvim configuration installed${RESET}"
	fi
}

select_component() {
	read choice
	case $choice in
	1) install_nvim ;;
	2) install_lazygit ;;
	3) install_yazi ;;
	4) install_bat_extra ;;
	5) install_clang_tools ;;
	6) install_lua_ls ;;
	7) install_python3_venv ;;
	8) install_debug_tools ;;
	9) install_nvim_config ;;
	*)
		echo -e "${YELLOW}Invalid input. Please enter a number between 1 and 9.${RESET}"
		exit 1
		;;
	esac
}

install_essential() {
	echo -e "${MAGENTA}[nvim]: Installing essential packages${RESET}"
	sudo apt-get install -y ninja-build cmake unzip zip curl build-essential luarocks graphviz \
		lua5.3 liblua5.3-dev fd-find ripgrep global sqlite3 libsqlite3-dev bat python3 \
		python3-dev flake8 bc

	# Install Node.js via nvm if needed
	if ! command -v nvm &>/dev/null; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
		source "$HOME/.nvm/nvm.sh"
	fi

	if ! command -v node &>/dev/null || [ $(node -v | cut -d. -f1 | tr -d 'v') -lt 20 ]; then
		nvm install 20
	fi

	# Install tree-sitter
	local ts_package=""
	if [ "$ARCH" = "ARM64" ]; then
		ts_package="tree-sitter-linux-arm64"
	else
		ts_package="tree-sitter-linux-x64"
	fi

	wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.25.3/${ts_package}.gz
	gunzip ${ts_package}.gz
	chmod +x ${ts_package}
	sudo mv ${ts_package} ${DEFAULT_PATH}/bin/tree-sitter
	rm -f ${ts_package}.gz

	# Install latex parser
	sudo apt-get install -y python3-pylatexenc

	echo -e "${GREEN}[SUCCESS] Essential packages installed${RESET}"
}

install_all() {
	install_nvim
	install_essential
	install_yazi
	install_lazygit
	install_bat_extra
	install_clang_tools
	install_lua_ls
	install_python3_venv
	install_debug_tools
}

process_arguments() {
	local operation_found=false

	while [ $# -gt 0 ]; do
		case "$1" in
		--prefix=*)
			local path="${1#*=}"
			if [ ! -d "$path" ]; then
				echo -e "${RED}Error: Specified path '$path' does not exist${RESET}"
				exit 1
			fi
			DEFAULT_PATH="${path%/}"
			echo -e "${GREEN}[nvim]: Installation path set to: ${DEFAULT_PATH}${RESET}"
			;;
		--arch=*)
			local arch="${1#*=}"
			if [[ "$arch" != "x86" && "$arch" != "ARM64" ]]; then
				echo -e "${RED}Error: Invalid architecture '$arch'. Must be x86 or ARM64${RESET}"
				exit 1
			fi
			ARCH="$arch"
			echo -e "${GREEN}[nvim]: Architecture set to: ${ARCH}${RESET}"
			;;
		all | basic | component | help)
			if [ "$operation_found" = true ]; then
				echo -e "${RED}Error: Only one operation can be specified${RESET}"
				show_help
				exit 1
			fi
			operation_found=true
			OPERATION="$1"
			;;
		*)
			echo -e "${RED}Error: Unknown argument '$1'${RESET}"
			show_help
			exit 1
			;;
		esac
		shift
	done

	if [ "$operation_found" = false ]; then
		show_help
	fi
}

main() {
	process_arguments "$@"

	case "$OPERATION" in
	all)
		echo -e "${MAGENTA}[nvim]: Installing all packages to ${DEFAULT_PATH} (ARCH=${ARCH})${RESET}"
		sudo apt-get update
		install_all
		install_nvim_config
		;;
	basic)
		echo -e "${MAGENTA}[nvim]: Installing basic packages to ${DEFAULT_PATH} (ARCH=${ARCH})${RESET}"
		sudo apt-get update
		install_nvim
		install_essential
		install_nvim_config
		;;
	component)
		show_components
		select_component
		;;
	help)
		show_help
		;;
	esac

	source $HOME/.bashrc
	echo -e "${GREEN}[nvim]: Installation completed!${RESET}"
}

main "$@"
