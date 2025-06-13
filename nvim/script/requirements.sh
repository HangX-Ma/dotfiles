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
# Operation mode
OPERATION="help"

# Default versions (as of 2023-11-01)
DEFAULT_NVIM_VERSION="0.9.4"
DEFAULT_LAZYGIT_VERSION="0.40.2"
DEFAULT_YAZI_VERSION="0.1.4"
DEFAULT_BAT_EXTRAS_VERSION="2023.03.21"
DEFAULT_CLANG_TOOLS_VERSION="17.0.0"
DEFAULT_LUA_LS_VERSION="3.6.23"
DEFAULT_NODE_LTS_VERSION="18.18.2"
DEFAULT_TREE_SITTER_VERSION="0.20.8"

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

create_installation_path() {
	local path="$1"
	local bin_path="${path}/bin"

	if [ ! -d "$path" ]; then
		echo -e "${YELLOW}[WARNING] Path '$path' does not exist, attempting to create...${RESET}"

		# Try to create without sudo first
		if ! mkdir -p "$path" 2>/dev/null; then
			echo -e "${YELLOW}[INFO] Need root privileges to create '$path'${RESET}"
			if ! sudo mkdir -p "$path"; then
				echo -e "${RED}[ERROR] Failed to create directory '$path'${RESET}"
				return 1
			fi
			# Ensure current user has write permission
			if [ "$(id -u)" -ne 0 ]; then
				sudo chown "$(id -u):$(id -g)" "$path"
			fi
		fi

		echo -e "${GREEN}[SUCCESS] Created directory '$path'${RESET}"
	fi

	if [ ! -d "$bin_path" ]; then
		echo -e "${YELLOW}[INFO] Bin directory '$bin_path' does not exist, creating...${RESET}"

		if ! mkdir -p "$bin_path" 2>/dev/null; then
			echo -e "${YELLOW}[INFO] Need root privileges to create '$bin_path'${RESET}"
			if ! sudo mkdir -p "$bin_path"; then
				echo -e "${RED}[ERROR] Failed to create bin directory '$bin_path'${RESET}"
				return 1
			fi
			# Ensure current user has write permission
			if [ "$(id -u)" -ne 0 ]; then
				sudo chown "$(id -u):$(id -g)" "$bin_path"
			fi
		fi

		echo -e "${GREEN}[SUCCESS] Created bin directory '$bin_path'${RESET}"
	fi

	if [ ! -w "$path" ]; then
		echo -e "${YELLOW}[WARNING] No write permission in '$path', attempting to fix...${RESET}"
		if ! sudo chown "$(id -u):$(id -g)" "$path"; then
			echo -e "${RED}[ERROR] Failed to set permissions for '$path'${RESET}"
			return 1
		fi
	fi

	if [ ! -w "$bin_path" ]; then
		echo -e "${YELLOW}[WARNING] No write permission in '$bin_path', attempting to fix...${RESET}"
		if ! sudo chown "$(id -u):$(id -g)" "$bin_path"; then
			echo -e "${RED}[ERROR] Failed to set permissions for '$bin_path'${RESET}"
			return 1
		fi
	fi

	return 0
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

# Function to compare versions
version_compare() {
	local v1=$1 v2=$2
	if [[ "$v1" == "$v2" ]]; then
		return 0
	fi
	local IFS=.
	local i ver1=($v1) ver2=($v2)
	for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
		ver1[i]=0
	done
	for ((i = 0; i < ${#ver1[@]}; i++)); do
		if [[ -z ${ver2[i]} ]]; then
			ver2[i]=0
		fi
		if ((10#${ver1[i]} > 10#${ver2[i]})); then
			return 1
		fi
		if ((10#${ver1[i]} < 10#${ver2[i]})); then
			return 2
		fi
	done
	return 0
}

get_latest_github_release() {
	local repo=$1
	local default_version=$2
	local version=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep -Po '"tag_name": "\K[^"]*' | sed 's/^v//')

	if [ -z "$version" ]; then
		echo -e "${YELLOW}[WARNING] Failed to get latest release for $repo, using default version $default_version${RESET}" >&2
		version="$default_version"
	fi

	echo "$version"
}

get_current_version() {
	local cmd=$1
	local version_cmd=$2
	if command -v $cmd &>/dev/null; then
		local current_version=$($cmd $version_cmd 2>&1 | grep -Po '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
		echo "$current_version"
	else
		echo ""
	fi
}

install_nvim() {
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi

	local PACKAGE_NAME=""
	if [ "$ARCH" = "ARM64" ]; then
		PACKAGE_NAME="arm64"
	else
		PACKAGE_NAME="x86_64"
	fi

	local LATEST_VERSION=$(get_latest_github_release "neovim/neovim" "$DEFAULT_NVIM_VERSION")

	# First check if command exists
	if ! command -v nvim &>/dev/null; then
		echo -e "${MAGENTA}[nvim]: Installing Neovim to ${DEFAULT_PATH} (ARCH=${ARCH})${RESET}"
	else
		# Only check version if command exists
		local CURRENT_VERSION=$(get_current_version "nvim" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[nvim]: Neovim is already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[nvim]: Neovim is newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[nvim]: Neovim is outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

	if ! wget -q "https://github.com/neovim/neovim/releases/download/v${LATEST_VERSION}/nvim-linux-${PACKAGE_NAME}.tar.gz"; then
		echo -e "${RED}[ERROR] Failed to download Neovim${RESET}"
		return 1
	fi

	tar xf "nvim-linux-${PACKAGE_NAME}.tar.gz"
	sudo cp -rf "nvim-linux-${PACKAGE_NAME}" "${DEFAULT_PATH}/"
	echo "export PATH=\"${DEFAULT_PATH}/nvim-linux-${PACKAGE_NAME}/bin:\$PATH\"" >>"$HOME/.bashrc"
	rm -rf "nvim-linux-${PACKAGE_NAME}"*

	export PATH="${DEFAULT_PATH}/nvim-linux-${PACKAGE_NAME}/bin:$PATH"
	verify_installation "Neovim" "nvim"
}

install_lazygit() {
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi

	local LATEST_VERSION=$(get_latest_github_release "jesseduffield/lazygit" "$DEFAULT_LAZYGIT_VERSION")

	# First check if command exists
	if ! command -v lazygit &>/dev/null; then
		echo -e "${MAGENTA}[lazygit]: Installing 'lazygit' to ${DEFAULT_PATH}/bin (ARCH=${ARCH})${RESET}"
	else
		# Only check version if command exists
		local CURRENT_VERSION=$(get_current_version "lazygit" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[lazygit]: Lazygit is already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[lazygit]: Lazygit is newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[lazygit]: Lazygit is outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

	if [ "$ARCH" = "ARM64" ]; then
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LATEST_VERSION}_Linux_arm64.tar.gz"
	else
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LATEST_VERSION}_Linux_x86_64.tar.gz"
	fi

	tar xf lazygit.tar.gz lazygit
	sudo cp -rf lazygit "${DEFAULT_PATH}/bin"
	rm -rf lazygit*

	export PATH="${DEFAULT_PATH}/bin:$PATH"
	verify_installation "Lazygit" "lazygit"
}

install_yazi() {
	local LATEST_VERSION=$(get_latest_github_release "sxyazi/yazi" "$DEFAULT_YAZI_VERSION")

	# First check if command exists
	if ! command -v yazi &>/dev/null; then
		echo -e "${MAGENTA}[yazi]: Installing 'yazi' TUI file manager${RESET}"
	else
		# Only check version if command exists
		local CURRENT_VERSION=$(get_current_version "yazi" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[yazi]: Yazi is already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[yazi]: Yazi is newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[yazi]: Yazi is outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

	if ! command -v rustup &>/dev/null; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
		echo '. "$HOME/.cargo/env"' >>"$HOME/.bashrc"
	fi
	source "$HOME/.cargo/env"
	rustup update
	cargo install --locked yazi-fm yazi-cli --force

	export PATH="$HOME/.cargo/bin:$PATH"
	verify_installation "Yazi" "yazi"
}

install_bat_extra() {
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi

	local LATEST_VERSION=$(get_latest_github_release "eth-p/bat-extras" "$DEFAULT_BAT_EXTRAS_VERSION")

	# First check if command exists
	if ! command -v batgrep &>/dev/null; then
		echo -e "${MAGENTA}[bat-extras]: Installing 'bat-extras' enhanced CLI tools${RESET}"
	else
		# Only check version if command exists
		local CURRENT_VERSION=$(get_current_version "batgrep" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[bat-extras]: bat-extras is already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[bat-extras]: bat-extras is newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[bat-extras]: bat-extras is outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

	sudo apt-get install -y gawk
	curl -sS https://webinstall.dev/shfmt | bash
	source "$HOME/.config/envman/PATH.env"

	git clone https://github.com/eth-p/bat-extras.git bat-extras
	cd bat-extras
	git checkout "$LATEST_VERSION"
	sudo ./build.sh --install --prefix="${DEFAULT_PATH}"
	cd ..
	sudo rm -rf bat-extras
	echo "export PATH=\"${DEFAULT_PATH}/bat-extras/bin:\$PATH\"" >>"$HOME/.bashrc"

	export PATH="${DEFAULT_PATH}/bat-extras/bin:$PATH"
	verify_installation "bat-extras" "batgrep"
}

install_clang_tools() {
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

	local LATEST_VERSION="$DEFAULT_CLANG_TOOLS_VERSION"

	# First check if command exists
	if ! command -v clangd &>/dev/null; then
		echo -e "${MAGENTA}[clang-tools]: Installing clang-tools (clangd, clang-format, LLVM) version $version${RESET}"
	else
		# Only check version if command exists
		local CURRENT_VERSION=$(get_current_version "clangd" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[clang-tools]: clang-tools are already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[clang-tools]: clang-tools are newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[clang-tools]: clang-tools are outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

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
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi

	local LATEST_TAG=$(get_latest_github_release "LuaLS/lua-language-server" "$DEFAULT_LUA_LS_VERSION")
	local LATEST_VERSION=${LATEST_TAG#v}

	if ! command -v lua-language-server &>/dev/null; then
		echo -e "${MAGENTA}[lua_ls]: Installing lua-language-server (ARCH=${ARCH})${RESET}"
	else
		local CURRENT_VERSION=$(get_current_version "lua-language-server" "--version")
		if [ -n "$CURRENT_VERSION" ]; then
			version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
			local cmp_result=$?

			if [ $cmp_result -eq 0 ]; then
				echo -e "${BLUE}[lua_ls]: lua-language-server is already up-to-date (v$CURRENT_VERSION)${RESET}"
				return 0
			elif [ $cmp_result -eq 1 ]; then
				echo -e "${BLUE}[lua_ls]: lua-language-server is newer than latest release (v$CURRENT_VERSION > v$LATEST_VERSION)${RESET}"
				return 0
			else
				echo -e "${YELLOW}[lua_ls]: lua-language-server is outdated (v$CURRENT_VERSION < v$LATEST_VERSION), updating...${RESET}"
			fi
		fi
	fi

	local DOWNLOAD_URL=""
	if [ "$ARCH" = "ARM64" ]; then
		DOWNLOAD_URL="https://github.com/LuaLS/lua-language-server/releases/download/${LATEST_TAG}/lua-language-server-${LATEST_VERSION}-linux-arm64.tar.gz"
	else
		DOWNLOAD_URL="https://github.com/LuaLS/lua-language-server/releases/download/${LATEST_TAG}/lua-language-server-${LATEST_VERSION}-linux-x64.tar.gz"
	fi

	echo -e "${CYAN}[INFO] Downloading lua-language-server from: $DOWNLOAD_URL${RESET}"

	if ! curl -Lo lua_ls.tar.gz "$DOWNLOAD_URL"; then
		echo -e "${RED}[ERROR] Failed to download lua-language-server${RESET}"
		return 1
	fi

	local TEMP_DIR=$(mktemp -d)
	mkdir -p "$TEMP_DIR/lua_ls"

	if ! tar xf lua_ls.tar.gz -C "$TEMP_DIR/lua_ls"; then
		echo -e "${RED}[ERROR] Failed to extract lua-language-server${RESET}"
		rm -rf "$TEMP_DIR"
		return 1
	fi

	sudo cp -rf "$TEMP_DIR/lua_ls" "${DEFAULT_PATH}/"
	echo "export PATH=\"${DEFAULT_PATH}/lua_ls/bin:\$PATH\"" >>"$HOME/.bashrc"

	rm -rf "$TEMP_DIR" lua_ls.tar.gz

	export PATH="${DEFAULT_PATH}/lua_ls/bin:$PATH"
	verify_installation "lua-language-server" "lua-language-server"
}

install_python3_venv() {
	if ! command -v python3 &>/dev/null; then
		echo -e "${MAGENTA}[python3-venv]: Installing Python 3${RESET}"
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo "${python_version}" | cut -d. -f2)

	if ((cut_version < 3)); then
		echo -e "${RED}[ERROR] Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		return 1
	fi

	if ! python3 -c "import venv" &>/dev/null; then
		echo -e "${MAGENTA}[python3-venv]: Installing python3-venv${RESET}"
		sudo apt-get install -y "python${python_version}-venv"
	fi

	echo -e "${GREEN}[SUCCESS] Python venv is ready (Python ${python_version})${RESET}"
}

install_debug_tools() {
	echo -e "${MAGENTA}[debug-tools]: Installing debug tools${RESET}"

	if ! command -v python3 &>/dev/null; then
		sudo apt-get install -y python3 python3-dev
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo "${python_version}" | cut -d. -f2)

	if ((cut_version < 3)); then
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
	read -r update_config

	if [[ $update_config != 'n' && $update_config != 'N' ]]; then
		echo -e "${MAGENTA}[nvim]: Installing nvim configuration${RESET}"
		if [ ! -d "dotfiles" ]; then
			git clone https://github.com/HangX-Ma/dotfiles.git
		fi
		[ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"
		cp -r dotfiles/nvim "$HOME/.config"
		[ -d "dotfiles" ] && rm -rf dotfiles
		echo -e "${GREEN}[SUCCESS] Nvim configuration installed${RESET}"
	fi
}

select_component() {
	read -r choice
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
	echo -e "${MAGENTA}[nvim]: Installing/updating essential packages${RESET}"
	sudo apt-get update

	# List of essential packages to install/update
	ESSENTIAL_PKGS=(ninja-build cmake unzip zip curl build-essential luarocks graphviz
		lua5.3 liblua5.3-dev fd-find ripgrep global sqlite3 libsqlite3-dev
		bat python3 python3-dev flake8 bc python3-pylatexenc)

	# Install/update essential packages
	sudo apt-get install -y "${ESSENTIAL_PKGS[@]}"

	# Install/update NVM and Node.js
	if ! command -v nvm &>/dev/null; then
		echo -e "${YELLOW}[INFO] Installing nvm...${RESET}"
		NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep 'tag_name' | cut -d'"' -f4)
		curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
		source "$HOME/.nvm/nvm.sh"
	else
		echo -e "${BLUE}[INFO] nvm is already installed${RESET}"
	fi

	# Get latest Node.js LTS version
	LATEST_LTS_VERSION="$DEFAULT_NODE_LTS_VERSION"
	if command -v node &>/dev/null; then
		CURRENT_NODE_VERSION=$(node -v | tr -d 'v')
		version_compare "$CURRENT_NODE_VERSION" "$LATEST_LTS_VERSION"
		case $? in
		0) echo -e "${BLUE}[INFO] Node.js is already up-to-date (v$CURRENT_NODE_VERSION)${RESET}" ;;
		1) echo -e "${BLUE}[INFO] Node.js is newer than LTS (v$CURRENT_NODE_VERSION > v$LATEST_LTS_VERSION)${RESET}" ;;
		2)
			echo -e "${YELLOW}[INFO] Updating Node.js from v$CURRENT_NODE_VERSION to v$LATEST_LTS_VERSION${RESET}"
			nvm install --lts
			nvm use --lts
			;;
		esac
	else
		echo -e "${YELLOW}[INFO] Installing Node.js LTS (v$LATEST_LTS_VERSION)${RESET}"
		nvm install --lts
		nvm use --lts
	fi

	# Install/update tree-sitter
	TS_LATEST_VERSION="$DEFAULT_TREE_SITTER_VERSION"
	TS_CURRENT_VERSION=$(command -v tree-sitter >/dev/null && tree-sitter --version | grep -o '[0-9.]*' || echo "0")

	version_compare "$TS_CURRENT_VERSION" "$TS_LATEST_VERSION"
	TS_NEED_UPDATE=$?

	if [[ $TS_NEED_UPDATE -eq 2 ]] || ! command -v tree-sitter &>/dev/null; then
		echo -e "${YELLOW}[INFO] Installing/updating tree-sitter...${RESET}"

		# Determine architecture
		local ts_package=""
		case "$(uname -m)" in
		aarch64 | arm64) ts_package="tree-sitter-linux-arm64" ;;
		x86_64) ts_package="tree-sitter-linux-x64" ;;
		*)
			echo -e "${RED}[ERROR] Unsupported architecture for tree-sitter${RESET}"
			sudo apt-get install -y tree-sitter
			return 0
			;;
		esac

		# Download and install tree-sitter
		TS_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TS_LATEST_VERSION}/${ts_package}.gz"
		if wget -q --spider "$TS_URL"; then
			wget -q "$TS_URL" -O "${ts_package}.gz"
			gunzip "${ts_package}.gz"
			chmod +x "$ts_package"
			sudo mv "$ts_package" "${DEFAULT_PATH}/bin/tree-sitter"
			rm -f "${ts_package}.gz"
			echo -e "${GREEN}[SUCCESS] tree-sitter updated to v${TS_LATEST_VERSION}${RESET}"
		else
			echo -e "${YELLOW}[WARNING] Failed to download tree-sitter, falling back to package manager${RESET}"
			sudo apt-get install -y tree-sitter
		fi
	else
		echo -e "${BLUE}[INFO] tree-sitter is already up-to-date (v${TS_CURRENT_VERSION})${RESET}"
	fi

	echo -e "${GREEN}[SUCCESS] Essential packages installation/update completed${RESET}"
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
			if ! create_installation_path "$path"; then
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
		install_all
		install_nvim_config
		;;
	basic)
		echo -e "${MAGENTA}[nvim]: Installing basic packages to ${DEFAULT_PATH} (ARCH=${ARCH})${RESET}"
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

	source "$HOME/.bashrc"
	echo -e "${GREEN}[nvim]: Installation completed!${RESET}"
	echo -e "${YELLOW}Note: You may need to run 'source ~/.bashrc' or open a new terminal for changes to take effect.${RESET}"
}

main "$@"
