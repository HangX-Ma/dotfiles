#!/bin/bash

# Color macros
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

# Default installation path (user-level to avoid sudo)
DEFAULT_PATH="${HOME}/.local"
# Default architecture
ARCH="x86"
# Operation mode
OPERATION="help"
# Auto-answer yes to sudo prompts when set to 1
ASSUME_YES=0
# Remembered answer to "use sudo?" prompt: unset | yes | no
SUDO_CHOICE=""

# Default versions (as of 2025-06-13)
DEFAULT_NVIM_VERSION="0.11.2"
DEFAULT_LAZYGIT_VERSION="0.52.0"
DEFAULT_YAZI_VERSION="25.5.31"
DEFAULT_BAT_EXTRAS_VERSION="2024.08.24"
DEFAULT_CLANG_TOOLS_VERSION="17.0.6"
DEFAULT_LUA_LS_VERSION="3.14.0"
DEFAULT_NODE_LTS_VERSION="22.16.0"
DEFAULT_TREE_SITTER_VERSION="0.25.6"

# sync: where to cache last-known-good upstream versions.
SYNC_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim-installer"
SYNC_CACHE_FILE="${SYNC_CACHE_DIR}/versions.env"
SYNC_DRY_RUN=0

# Each entry: "<var_name>|<fetcher spec>|<x86_url_template>|<arm_url_template>"
# Fetcher spec: "gh:owner/repo"  OR  "node-lts" (special-cased).
# URL templates use %V for version (no leading 'v').
SYNC_PACKAGES=(
	"DEFAULT_NVIM_VERSION|gh:neovim/neovim|https://github.com/neovim/neovim/releases/download/v%V/nvim-linux-x86_64.tar.gz|https://github.com/neovim/neovim/releases/download/v%V/nvim-linux-arm64.tar.gz"
	"DEFAULT_LAZYGIT_VERSION|gh:jesseduffield/lazygit|https://github.com/jesseduffield/lazygit/releases/download/v%V/lazygit_%V_Linux_x86_64.tar.gz|https://github.com/jesseduffield/lazygit/releases/download/v%V/lazygit_%V_Linux_arm64.tar.gz"
	"DEFAULT_YAZI_VERSION|gh:sxyazi/yazi|https://github.com/sxyazi/yazi/releases/tag/v%V|https://github.com/sxyazi/yazi/releases/tag/v%V"
	"DEFAULT_BAT_EXTRAS_VERSION|gh:eth-p/bat-extras|https://github.com/eth-p/bat-extras/archive/refs/tags/v%V.tar.gz|https://github.com/eth-p/bat-extras/archive/refs/tags/v%V.tar.gz"
	"DEFAULT_CLANG_TOOLS_VERSION|gh:llvm/llvm-project|https://github.com/llvm/llvm-project/releases/download/llvmorg-%V/clang+llvm-%V-x86_64-linux-gnu-ubuntu-22.04.tar.xz|https://github.com/llvm/llvm-project/releases/download/llvmorg-%V/clang+llvm-%V-aarch64-linux-gnu.tar.xz"
	"DEFAULT_LUA_LS_VERSION|gh:LuaLS/lua-language-server|https://github.com/LuaLS/lua-language-server/releases/download/%V/lua-language-server-%V-linux-x64.tar.gz|https://github.com/LuaLS/lua-language-server/releases/download/%V/lua-language-server-%V-linux-arm64.tar.gz"
	"DEFAULT_NODE_LTS_VERSION|node-lts|https://nodejs.org/dist/v%V/node-v%V-linux-x64.tar.xz|https://nodejs.org/dist/v%V/node-v%V-linux-arm64.tar.xz"
	"DEFAULT_TREE_SITTER_VERSION|gh:tree-sitter/tree-sitter|https://github.com/tree-sitter/tree-sitter/releases/download/v%V/tree-sitter-linux-x64.gz|https://github.com/tree-sitter/tree-sitter/releases/download/v%V/tree-sitter-linux-arm64.gz"
)

show_help() {
	echo -e "\nUsage: $0 [all|basic|component|sync|help] [options]"
	echo "Operations:"
	echo "    all       - Install all packages"
	echo "    basic     - Install basic component to support nvim functions"
	echo "    component - Install component that you need"
	echo "    sync      - Fetch & HEAD-verify latest upstream versions; update DEFAULT_*_VERSION in this script"
	echo "    help      - Show this usage guidance information"
	echo -e "\nOptions:"
	echo "    --prefix=PATH   - Specify installation path (default: \$HOME/.local)"
	echo "    --arch=ARCH     - Specify architecture (x86 or ARM64, default: x86)"
	echo "    --dry-run       - (sync only) Print planned changes, don't modify the script"
	echo -e "    -y              - Automatically answer 'yes' to sudo prompts\n"
	echo -e "\nEnvironment:"
	echo "    GITHUB_TOKEN / GH_TOKEN - Optional. When set, GitHub API calls are authenticated"
	echo "                              (raises rate limit from 60/hr to 5000/hr)."
	echo -e "\nExamples:"
	echo "    $0 all --prefix=\$HOME/.local"
	echo "    $0 basic --prefix=/opt --arch=ARM64"
	echo "    $0 component --arch=ARM64"
	echo -e "    GITHUB_TOKEN=ghp_... $0 sync --dry-run\n"
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

# Ask the user whether to escalate via sudo for the described action.
# Returns 0 if sudo should be used, 1 if skipped/denied.
# The decision for the whole session is cached in SUDO_CHOICE after the first prompt.
ask_use_sudo() {
	local reason="$1"

	# Already root? No sudo needed — caller can just run the command directly.
	if [ "$(id -u)" -eq 0 ]; then
		return 0
	fi

	if ! command -v sudo &>/dev/null; then
		echo -e "${YELLOW}[INFO] 'sudo' is not available; cannot escalate for: ${reason}${RESET}"
		return 1
	fi

	if [ "$SUDO_CHOICE" = "yes" ]; then
		return 0
	fi
	if [ "$SUDO_CHOICE" = "no" ]; then
		return 1
	fi

	if [ "$ASSUME_YES" = "1" ]; then
		SUDO_CHOICE="yes"
		return 0
	fi

	echo -e "${YELLOW}[PROMPT] ${reason}${RESET}"
	echo -en "${YELLOW}        This step needs root privileges. Use 'sudo' now? [y/N]: ${RESET}"
	local answer=""
	# Prefer /dev/tty so answers work even when stdin is a pipe; fall back
	# to stdin if a controlling terminal isn't available (e.g., CI).
	if { true </dev/tty; } 2>/dev/null; then
		read -r answer </dev/tty || answer=""
	else
		read -r answer || answer=""
	fi
	case "$answer" in
	y | Y | yes | YES)
		SUDO_CHOICE="yes"
		return 0
		;;
	*)
		SUDO_CHOICE="no"
		return 1
		;;
	esac
}

# Run a command; use sudo only if the target action needs it and the user agrees.
# Usage: maybe_sudo "<reason shown to user>" <cmd> [args...]
# Returns the command's exit status, or 1 if sudo was needed but declined.
maybe_sudo() {
	local reason="$1"
	shift
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
		return $?
	fi
	if ask_use_sudo "$reason"; then
		sudo "$@"
		return $?
	fi
	echo -e "${YELLOW}[SKIP] User declined sudo; skipping: $*${RESET}"
	return 1
}

create_installation_path() {
	local path="$1"
	local bin_path="${path}/bin"

	if [ ! -d "$path" ]; then
		echo -e "${YELLOW}[WARNING] Path '$path' does not exist, attempting to create...${RESET}"

		if ! mkdir -p "$path" 2>/dev/null; then
			if ! maybe_sudo "Create installation directory '$path'" mkdir -p "$path"; then
				echo -e "${RED}[ERROR] Failed to create directory '$path'${RESET}"
				return 1
			fi
			maybe_sudo "Take ownership of '$path'" chown "$(id -u):$(id -g)" "$path" >/dev/null || true
		fi

		echo -e "${GREEN}[SUCCESS] Created directory '$path'${RESET}"
	fi

	if [ ! -d "$bin_path" ]; then
		echo -e "${YELLOW}[INFO] Bin directory '$bin_path' does not exist, creating...${RESET}"

		if ! mkdir -p "$bin_path" 2>/dev/null; then
			if ! maybe_sudo "Create bin directory '$bin_path'" mkdir -p "$bin_path"; then
				echo -e "${RED}[ERROR] Failed to create bin directory '$bin_path'${RESET}"
				return 1
			fi
			maybe_sudo "Take ownership of '$bin_path'" chown "$(id -u):$(id -g)" "$bin_path" >/dev/null || true
		fi

		echo -e "${GREEN}[SUCCESS] Created bin directory '$bin_path'${RESET}"
	fi

	if [ ! -w "$path" ]; then
		echo -e "${YELLOW}[WARNING] No write permission in '$path', attempting to fix...${RESET}"
		if ! maybe_sudo "Fix ownership of '$path'" chown "$(id -u):$(id -g)" "$path"; then
			echo -e "${RED}[ERROR] Failed to set permissions for '$path'${RESET}"
			return 1
		fi
	fi

	if [ ! -w "$bin_path" ]; then
		echo -e "${YELLOW}[WARNING] No write permission in '$bin_path', attempting to fix...${RESET}"
		if ! maybe_sudo "Fix ownership of '$bin_path'" chown "$(id -u):$(id -g)" "$bin_path"; then
			echo -e "${RED}[ERROR] Failed to set permissions for '$bin_path'${RESET}"
			return 1
		fi
	fi

	return 0
}

# Copy/move something into the prefix. Uses sudo only when prefix is not user-writable.
# Usage: install_to_prefix <dest_dir> <op> <args...>
#   op: "cp-r"  -> cp -rf <src> <dest>
#       "mv"    -> mv <src> <dest>
install_to_prefix() {
	local dest="$1"
	local op="$2"
	shift 2

	local cmd=()
	case "$op" in
	cp-r) cmd=(cp -rf "$@" "$dest") ;;
	mv) cmd=(mv "$@" "$dest") ;;
	*)
		echo -e "${RED}[ERROR] install_to_prefix: unknown op '$op'${RESET}"
		return 1
		;;
	esac

	if [ -w "$dest" ]; then
		"${cmd[@]}"
	else
		maybe_sudo "Install files into '$dest'" "${cmd[@]}"
	fi
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

# Emit curl args for an authenticated GitHub API request when GITHUB_TOKEN or
# GH_TOKEN is set. Unauthenticated requests share a 60/hour per-IP quota, which
# is easy to exhaust on shared NAT'd networks; a token raises it to 5000/hour.
gh_auth_args() {
	local token="${GITHUB_TOKEN:-${GH_TOKEN:-}}"
	if [ -n "$token" ]; then
		printf '%s\n' "-H" "Authorization: Bearer ${token}"
	fi
}

get_latest_github_release() {
	local repo=$1
	local default_version=$2
	local auth_args=()
	mapfile -t auth_args < <(gh_auth_args)

	local response http_code
	response=$(curl -sSL -w $'\n%{http_code}' --max-time 15 \
		"${auth_args[@]}" \
		-H "Accept: application/vnd.github+json" \
		"https://api.github.com/repos/$repo/releases/latest" 2>/dev/null)
	http_code="${response##*$'\n'}"
	response="${response%$'\n'*}"

	local version=""
	if [[ "$http_code" =~ ^2[0-9][0-9]$ ]]; then
		# Strip common tag prefixes: plain "v", LLVM's "llvmorg-".
		version=$(printf '%s' "$response" \
			| grep -Po '"tag_name": "\K[^"]*' \
			| sed -e 's/^llvmorg-//' -e 's/^v//')
	fi

	if [ -z "$version" ]; then
		if [ "$http_code" = "403" ] && [ ${#auth_args[@]} -eq 0 ]; then
			echo -e "${YELLOW}[WARNING] GitHub API rate-limited for $repo (HTTP 403). Set GITHUB_TOKEN or GH_TOKEN to raise the quota. Using default version $default_version${RESET}" >&2
		else
			echo -e "${YELLOW}[WARNING] Failed to get latest release for $repo (HTTP ${http_code:-?}), using default version $default_version${RESET}" >&2
		fi
		version="$default_version"
	fi

	echo "$version"
}

# HEAD-check a URL; 0 = exists (2xx/3xx), 1 = missing. Prefers curl
# (follows redirects cleanly); falls back to wget --spider.
url_exists() {
	local url=$1
	if command -v curl &>/dev/null; then
		local code
		code=$(curl -sSL -o /dev/null -w '%{http_code}' --max-time 15 -I "$url" 2>/dev/null)
		[[ "$code" =~ ^(2|3)[0-9][0-9]$ ]]
	else
		wget -q --spider --timeout=15 "$url"
	fi
}

# Resolve the latest Node.js LTS version via nodejs.org/dist/index.json.
# Parses without jq: the first entry whose "lts" field is a non-false string
# is the current LTS on that JSON feed.
get_latest_node_lts() {
	local default=$1
	local json
	json=$(curl -sSL --max-time 15 "https://nodejs.org/dist/index.json" 2>/dev/null)
	if [ -z "$json" ]; then
		echo "$default"
		return
	fi
	local version
	version=$(printf '%s' "$json" |
		grep -oP '\{[^{}]*"lts":\s*"[^"]+"[^{}]*\}' |
		head -n 1 |
		grep -oP '"version":\s*"v\K[0-9.]+(?=")')
	[ -z "$version" ] && version="$default"
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

	for i in {1..3}; do
		wget -q "https://github.com/neovim/neovim/releases/download/v${LATEST_VERSION}/nvim-linux-${PACKAGE_NAME}.tar.gz" && break
		echo -e "${RED}[WARNING] Attempt $i failed${RESET}"
		sleep 2
	done || {
		echo -e "${RED}[ERROR] Failed to download Neovim after 3 attempts${RESET}"
		return 1
	}

	tar xf "nvim-linux-${PACKAGE_NAME}.tar.gz"
	if ! install_to_prefix "${DEFAULT_PATH}/" "cp-r" "nvim-linux-${PACKAGE_NAME}"; then
		rm -rf "nvim-linux-${PACKAGE_NAME}"*
		return 1
	fi

	local nvim_bin="${DEFAULT_PATH}/nvim-linux-${PACKAGE_NAME}/bin"
	append_path_to_rc "$nvim_bin"
	rm -rf "nvim-linux-${PACKAGE_NAME}"*

	export PATH="${nvim_bin}:$PATH"
	verify_installation "Neovim" "nvim"
}

# Append an "export PATH" line to the user's shell rc if not already present.
append_path_to_rc() {
	local bin_dir="$1"
	local line="export PATH=\"${bin_dir}:\$PATH\""
	local rc=""
	# Pick an rc file the user actually uses; fall back to .bashrc.
	if [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
		rc="$HOME/.bashrc"
	elif [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
		rc="$HOME/.zshrc"
	else
		rc="$HOME/.profile"
	fi
	[ -f "$rc" ] || touch "$rc"
	if ! grep -Fq "$bin_dir" "$rc"; then
		echo "$line" >>"$rc"
		echo -e "${CYAN}[INFO] Added '${bin_dir}' to PATH via ${rc}${RESET}"
	fi
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
	if ! install_to_prefix "${DEFAULT_PATH}/bin" "cp-r" lazygit; then
		rm -rf lazygit*
		return 1
	fi
	rm -rf lazygit*

	export PATH="${DEFAULT_PATH}/bin:$PATH"
	append_path_to_rc "${DEFAULT_PATH}/bin"
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
	# Upstream packaging: since yazi 26.x, `yazi-fm`/`yazi-cli` on crates.io
	# refuse to be built via `cargo install` directly (they require the
	# yazi-build meta-crate's build.rs cascade, which only fires reliably under
	# specific manifest paths). The stable documented path is `git clone` +
	# `cargo build --release --locked`, producing plain binaries we copy into
	# the prefix ourselves.
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi
	local yazi_src
	yazi_src=$(mktemp -d)
	git clone --depth 1 https://github.com/sxyazi/yazi.git "$yazi_src/yazi" || {
		echo -e "${RED}[ERROR] Failed to clone yazi repo${RESET}"
		rm -rf "$yazi_src"
		return 1
	}
	(cd "$yazi_src/yazi" && cargo build --release --locked) || {
		echo -e "${RED}[ERROR] yazi build failed${RESET}"
		rm -rf "$yazi_src"
		return 1
	}
	if ! install_to_prefix "${DEFAULT_PATH}/bin" "cp-r" \
		"$yazi_src/yazi/target/release/yazi" \
		"$yazi_src/yazi/target/release/ya"; then
		rm -rf "$yazi_src"
		return 1
	fi
	rm -rf "$yazi_src"

	export PATH="${DEFAULT_PATH}/bin:$PATH"
	append_path_to_rc "${DEFAULT_PATH}/bin"
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

	if ! command -v gawk &>/dev/null; then
		if ! maybe_sudo "Install 'gawk' (required by bat-extras)" apt-get install -y gawk; then
			echo -e "${YELLOW}[SKIP] Skipping bat-extras: 'gawk' is missing and sudo was declined${RESET}"
			return 1
		fi
	fi

	git clone https://github.com/eth-p/bat-extras.git bat-extras
	cd bat-extras || return 1
	git checkout "v${LATEST_VERSION}"

	if [ -w "${DEFAULT_PATH}" ]; then
		./build.sh --install --minify=none --prefix="${DEFAULT_PATH}"
	else
		maybe_sudo "Install bat-extras into '${DEFAULT_PATH}'" ./build.sh --install --minify=none --prefix="${DEFAULT_PATH}"
	fi
	cd ..
	rm -rf bat-extras

	verify_installation "bat-extras" "batgrep"
}

install_clang_tools() {
	if ! create_installation_path "${DEFAULT_PATH}"; then
		return 1
	fi

	# LLVM release file names are asymmetric:
	#   aarch64-linux-gnu.tar.xz
	#   x86_64-linux-gnu-ubuntu-22.04.tar.xz  (suffix differs per LLVM release)
	local pkg_triple=""
	case "$ARCH" in
	x86 | x86_64) pkg_triple="x86_64-linux-gnu-ubuntu-22.04" ;;
	ARM64 | aarch64 | arm64) pkg_triple="aarch64-linux-gnu" ;;
	*)
		echo "Unsupported architecture: $ARCH"
		return 1
		;;
	esac

	# LLVM doesn't ship prebuilt tarballs for every release — only select
	# minor versions have x86_64-linux-gnu-ubuntu-*.tar.xz. Fall back to the
	# pinned default when the latest upstream version has no matching asset.
	local LATEST_VERSION=$(get_latest_github_release "llvm/llvm-project" "$DEFAULT_CLANG_TOOLS_VERSION")
	local candidate_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LATEST_VERSION}/clang+llvm-${LATEST_VERSION}-${pkg_triple}.tar.xz"
	if ! url_exists "$candidate_url"; then
		echo -e "${YELLOW}[clang-tools]: No prebuilt ${pkg_triple} asset for v${LATEST_VERSION}; falling back to pinned v${DEFAULT_CLANG_TOOLS_VERSION}${RESET}" >&2
		LATEST_VERSION="$DEFAULT_CLANG_TOOLS_VERSION"
	fi
	local version="${LATEST_VERSION%%.*}"

	# First check if command exists
	if ! command -v clangd &>/dev/null; then
		echo -e "${MAGENTA}[clang-tools]: Installing clang-tools v${LATEST_VERSION} (clangd, clang-format, LLVM) into ${DEFAULT_PATH}${RESET}"
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
	local start_dir="$PWD"
	cd "$temp_dir" || return 1

	local pkg_dir="clang+llvm-${LATEST_VERSION}-${pkg_triple}"
	local package_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LATEST_VERSION}/${pkg_dir}.tar.xz"

	echo "Downloading LLVM tools from $package_url ..."
	if ! wget -q "$package_url"; then
		echo -e "${RED}[ERROR] Failed to download LLVM tools${RESET}"
		cd "$start_dir"
		rm -rf "$temp_dir"
		return 1
	fi

	echo "Extracting ${pkg_dir}.tar.xz ..."
	if ! tar -xf "${pkg_dir}.tar.xz"; then
		echo -e "${RED}[ERROR] Failed to extract package${RESET}"
		cd "$start_dir"
		rm -rf "$temp_dir"
		return 1
	fi

	echo "Installing clang-tools to ${DEFAULT_PATH} ..."
	# Use shell glob with a trailing slash to expand into many args.
	local src_files=("$pkg_dir"/*)
	if ! install_to_prefix "${DEFAULT_PATH}/" "cp-r" "${src_files[@]}"; then
		echo -e "${RED}[ERROR] Failed to install clang-tools${RESET}"
		cd "$start_dir"
		rm -rf "$temp_dir"
		return 1
	fi

	cd "$start_dir" >/dev/null
	rm -rf "$temp_dir"

	export PATH="${DEFAULT_PATH}/bin:$PATH"
	append_path_to_rc "${DEFAULT_PATH}/bin"

	echo -e "${GREEN}[SUCCESS] Clang tools installed successfully${RESET}"
	command -v clangd >/dev/null && echo "clangd version: $(clangd --version)"
	command -v clang-format >/dev/null && echo "clang-format version: $(clang-format --version)"
	command -v clang >/dev/null && echo "clang version: $(clang --version | head -n 1)"
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

	curl -fLo lua_ls.tar.gz "${DOWNLOAD_URL}"
	if [ ! -f lua_ls.tar.gz ]; then
		echo -e "${RED}[ERROR] Failed to download lua-language-server${RESET}"
		return 1
	fi

	FILE_TYPE=$(file --mime-type lua_ls.tar.gz | awk '{print $2}')
	if [ "$FILE_TYPE" != "application/gzip" ]; then
		echo -e "${RED}[ERROR] The downloaded file is not a valid .tar.gz archive (detected type: $FILE_TYPE)${RESET}"
		return 1
	fi

	local TEMP_DIR=$(mktemp -d)
	mkdir -p "$TEMP_DIR/lua_ls"

	tar xf lua_ls.tar.gz -C "$TEMP_DIR/lua_ls"

	# The lua-language-server ELF needs its sibling runtime (main.lua, meta/,
	# script/, locale/, bin/main.lua) next to it, so install the whole bundle
	# under <prefix>/lua-language-server/ and drop a wrapper shim into bin/.
	local lua_ls_dir="${DEFAULT_PATH}/lua-language-server"
	if [ -d "$lua_ls_dir" ]; then
		if [ -w "${DEFAULT_PATH}" ]; then
			rm -rf "$lua_ls_dir"
		else
			maybe_sudo "Remove previous lua-language-server bundle" rm -rf "$lua_ls_dir" || true
		fi
	fi
	if ! install_to_prefix "${DEFAULT_PATH}/" "mv" "$TEMP_DIR/lua_ls"; then
		rm -rf "$TEMP_DIR" lua_ls.tar.gz
		return 1
	fi
	# Rename lua_ls -> lua-language-server under the prefix.
	if [ -w "${DEFAULT_PATH}" ]; then
		mv "${DEFAULT_PATH}/lua_ls" "$lua_ls_dir"
	else
		maybe_sudo "Rename lua_ls bundle" mv "${DEFAULT_PATH}/lua_ls" "$lua_ls_dir" || {
			rm -rf "$TEMP_DIR" lua_ls.tar.gz
			return 1
		}
	fi
	# Remove any stale shim from an older buggy install, then write a wrapper
	# that exec's the real binary with its runtime sitting alongside.
	if [ -e "${DEFAULT_PATH}/bin/lua-language-server" ]; then
		if [ -w "${DEFAULT_PATH}/bin" ]; then
			rm -f "${DEFAULT_PATH}/bin/lua-language-server"
		else
			maybe_sudo "Remove stale lua-language-server shim" rm -f "${DEFAULT_PATH}/bin/lua-language-server" || true
		fi
	fi
	local shim="$TEMP_DIR/lua-language-server"
	cat >"$shim" <<EOF
#!/bin/sh
exec "${lua_ls_dir}/bin/lua-language-server" "\$@"
EOF
	chmod +x "$shim"
	if ! install_to_prefix "${DEFAULT_PATH}/bin" "mv" "$shim"; then
		rm -rf "$TEMP_DIR" lua_ls.tar.gz
		return 1
	fi

	rm -rf "$TEMP_DIR" lua_ls.tar.gz

	export PATH="${DEFAULT_PATH}/bin:$PATH"
	append_path_to_rc "${DEFAULT_PATH}/bin"
	verify_installation "lua-language-server" "lua-language-server"
}

install_python3_venv() {
	if ! command -v python3 &>/dev/null; then
		echo -e "${MAGENTA}[python3-venv]: Python 3 is missing${RESET}"
		if ! maybe_sudo "Install 'python3 python3-dev' system-wide" apt-get install -y python3 python3-dev; then
			echo -e "${YELLOW}[SKIP] Skipping python3-venv: could not install python3 (sudo declined or apt failed)${RESET}"
			return 1
		fi
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo "${python_version}" | cut -d. -f2)

	if ((cut_version < 3)); then
		echo -e "${RED}[ERROR] Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		return 1
	fi

	if ! python3 -c "import venv" &>/dev/null; then
		echo -e "${MAGENTA}[python3-venv]: 'venv' module missing${RESET}"
		if ! maybe_sudo "Install 'python${python_version}-venv' system-wide" apt-get install -y "python${python_version}-venv"; then
			echo -e "${YELLOW}[SKIP] Could not install python${python_version}-venv without sudo${RESET}"
			return 1
		fi
	fi

	echo -e "${GREEN}[SUCCESS] Python venv is ready (Python ${python_version})${RESET}"
}

install_debug_tools() {
	echo -e "${MAGENTA}[debug-tools]: Installing debug tools${RESET}"

	if ! command -v python3 &>/dev/null; then
		if ! maybe_sudo "Install 'python3 python3-dev' system-wide" apt-get install -y python3 python3-dev; then
			echo -e "${YELLOW}[SKIP] Skipping debug-tools: could not install python3 (sudo declined or apt failed)${RESET}"
			return 1
		fi
	fi

	python_version=$(python3 --version 2>&1 | sed -n 's/.* \([0-9]*\.[0-9]*\).*/\1/p')
	cut_version=$(echo "${python_version}" | cut -d. -f2)

	if ((cut_version < 3)); then
		echo -e "${RED}[ERROR] Python 3 version must be at least 3.3. Current version is ${python_version}.${RESET}"
		return 1
	fi

	if ! python3 -c "import debugpy" &>/dev/null; then
		# Prefer pip --user so no root is needed. python3-debugpy isn't packaged
		# on Ubuntu 22.04, so always ensure pip3 is available first.
		if ! command -v pip3 &>/dev/null; then
			echo -e "${CYAN}[INFO] pip3 missing; installing python3-pip${RESET}"
			if ! maybe_sudo "Install 'python3-pip' system-wide" apt-get install -y python3-pip; then
				echo -e "${YELLOW}[SKIP] debug-tools: cannot install debugpy without pip3${RESET}"
				return 1
			fi
		fi
		echo -e "${CYAN}[INFO] Installing debugpy via 'pip3 install --user'${RESET}"
		if ! pip3 install --user debugpy; then
			echo -e "${RED}[ERROR] Failed to install debugpy via pip3${RESET}"
			return 1
		fi
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

	# List of essential packages to install/update
	ESSENTIAL_PKGS=(ninja-build cmake unzip zip curl build-essential luarocks graphviz
		lua5.3 liblua5.3-dev fd-find ripgrep global sqlite3 libsqlite3-dev
		bat python3 python3-dev flake8 bc)

	if ! maybe_sudo "Install essential apt packages (${ESSENTIAL_PKGS[*]})" apt-get update; then
		echo -e "${YELLOW}[SKIP] Skipping apt-based essentials; user declined sudo. You may need to install these manually: ${ESSENTIAL_PKGS[*]}${RESET}"
	else
		maybe_sudo "Install essential apt packages" apt-get install -y "${ESSENTIAL_PKGS[@]}" || true
	fi

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
			maybe_sudo "Install 'tree-sitter' via apt (unsupported arch fallback)" apt-get install -y tree-sitter || true
			return 0
			;;
		esac

		# Download and install tree-sitter
		TS_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TS_LATEST_VERSION}/${ts_package}.gz"
		if wget -q --spider "$TS_URL"; then
			wget -q "$TS_URL" -O "${ts_package}.gz"
			gunzip "${ts_package}.gz"
			chmod +x "$ts_package"
			if [ -w "${DEFAULT_PATH}/bin" ] 2>/dev/null || create_installation_path "${DEFAULT_PATH}"; then
				if [ -w "${DEFAULT_PATH}/bin" ]; then
					mv "$ts_package" "${DEFAULT_PATH}/bin/tree-sitter"
				else
					maybe_sudo "Install 'tree-sitter' into ${DEFAULT_PATH}/bin" mv "$ts_package" "${DEFAULT_PATH}/bin/tree-sitter" || rm -f "$ts_package"
				fi
			fi
			rm -f "${ts_package}.gz"
			echo -e "${GREEN}[SUCCESS] tree-sitter updated to v${TS_LATEST_VERSION}${RESET}"
		else
			echo -e "${YELLOW}[WARNING] Failed to download tree-sitter, falling back to package manager${RESET}"
			maybe_sudo "Install 'tree-sitter' via apt" apt-get install -y tree-sitter || true
		fi
	else
		echo -e "${BLUE}[INFO] tree-sitter is already up-to-date (v${TS_CURRENT_VERSION})${RESET}"
	fi

	echo -e "${GREEN}[SUCCESS] Essential packages installation/update completed${RESET}"
}

cmd_sync() {
	mkdir -p "$SYNC_CACHE_DIR"
	local script_path
	script_path="$(readlink -f "${BASH_SOURCE[0]}")"

	echo -e "${MAGENTA}[sync]: Resolving latest upstream versions...${RESET}"

	local -a drifts=()      # "VAR_NAME|old|new"
	local -a cache_lines=() # "VAR_NAME=new"
	local -a skipped=()

	local entry var_name fetcher url_x86 url_arm
	for entry in "${SYNC_PACKAGES[@]}"; do
		IFS='|' read -r var_name fetcher url_x86 url_arm <<<"$entry"

		local current_default
		current_default="$(grep -oP "^${var_name}=\"\K[^\"]+" "$script_path" || echo "")"

		local latest=""
		case "$fetcher" in
		gh:*) latest=$(get_latest_github_release "${fetcher#gh:}" "$current_default") ;;
		node-lts) latest=$(get_latest_node_lts "$current_default") ;;
		esac

		if [ -z "$latest" ]; then
			echo -e "${YELLOW}  [skip] $var_name: could not resolve latest version${RESET}"
			skipped+=("$var_name")
			cache_lines+=("${var_name}=${current_default}")
			continue
		fi

		# HEAD-verify both arch URLs before accepting the resolved version.
		# Even on "unchanged", verifying makes the cache a trusted snapshot.
		local ux=${url_x86//%V/$latest}
		local ua=${url_arm//%V/$latest}
		local verify_ok=1
		if ! url_exists "$ux"; then
			echo -e "${YELLOW}  [skip] $var_name: x86 asset 404 at $ux${RESET}"
			verify_ok=0
		elif ! url_exists "$ua"; then
			echo -e "${YELLOW}  [skip] $var_name: arm64 asset 404 at $ua${RESET}"
			verify_ok=0
		fi

		if [ $verify_ok -eq 0 ]; then
			skipped+=("$var_name")
			cache_lines+=("${var_name}=${current_default}")
			continue
		fi

		cache_lines+=("${var_name}=${latest}")
		if [ "$latest" = "$current_default" ]; then
			printf "  %-30s %s (unchanged, verified)\n" "$var_name" "$latest"
		else
			drifts+=("${var_name}|${current_default}|${latest}")
			printf "  %-30s %s -> %s\n" "$var_name" "$current_default" "$latest"
		fi
	done

	# Always write cache, even with zero drift — doubles as an offline snapshot.
	{
		echo "# Generated by requirements.sh sync on $(date -u +%FT%TZ)"
		printf '%s\n' "${cache_lines[@]}"
	} >"$SYNC_CACHE_FILE"
	echo -e "${CYAN}[sync] Cache written: $SYNC_CACHE_FILE${RESET}"

	if [ ${#drifts[@]} -eq 0 ]; then
		echo -e "${GREEN}[sync] All pinned versions already match upstream.${RESET}"
		if [ ${#skipped[@]} -gt 0 ]; then
			echo -e "${YELLOW}[sync] Skipped ${#skipped[@]} package(s) whose assets didn't verify: ${skipped[*]}${RESET}"
		fi
		return 0
	fi

	if [ "$SYNC_DRY_RUN" = "1" ]; then
		echo -e "${YELLOW}[sync] --dry-run: ${#drifts[@]} version(s) would be updated; script untouched.${RESET}"
		return 0
	fi

	cp -f "$script_path" "${script_path}.bak"
	echo -e "${CYAN}[sync] Backup saved: ${script_path}.bak${RESET}"

	local d var old new
	for d in "${drifts[@]}"; do
		IFS='|' read -r var old new <<<"$d"
		sed -i "s|^${var}=\"${old}\"|${var}=\"${new}\"|" "$script_path"
	done
	echo -e "${GREEN}[sync] Updated ${#drifts[@]} pinned version(s) in ${script_path}${RESET}"
	if [ ${#skipped[@]} -gt 0 ]; then
		echo -e "${YELLOW}[sync] Skipped ${#skipped[@]} package(s) whose assets didn't verify: ${skipped[*]}${RESET}"
	fi
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
		-y)
			ASSUME_YES=1
			SUDO_CHOICE="yes"
			echo -e "${GREEN}[nvim]: Auto-answering 'yes' to sudo prompts${RESET}"
			;;
		--dry-run)
			SYNC_DRY_RUN=1
			;;
		all | basic | component | sync | help)
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
	sync)
		cmd_sync
		return $?
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
