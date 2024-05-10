# Configure Neovim

You can follow the steps in this `README` file or read the blog [\[Start from scratch: Neovim\]](https://hangx-ma.github.io/2023/06/23/neovim-config.html) to configure Neovim.

<div class="dino" align="center">
  <table>
    <tr>
      <td><img src="./assets/nvim-statup.png" alt="Neovim: Statup Page" width=500 />
      <td><img src="./assets/nvim-main.png" alt="Neovim: Main Page" width=500 />
    </tr>
    <tr>
      <td align="center"><font size="2" color="#999"><u>Neovim: Statup Page</u></font></td>
      <td align="center"><font size="2" color="#999"><u>Neovim: Main Page</u></font></td>
    </tr>
  </table>
</div>

> [!NOTE]
> **_requirements.sh_** provides you a convenient installation method. Just run `. ./requirements.sh help` and follow the guidance. It may ask you privileged right to install necessary packages.
>
> **You must run the script under current shell environment using `. ./requirements.sh all`. Otherwise, the environment variables take no effect!**
>
> ```txt
> Usage:  [all|basic|component|help]"
>     all       - Install all packages"
>     basic     - Install basic component to support nvim functions(Default)"
>     component - Install component that you need"
>     help      - Show this usage guidance information\n"
> ```

> [!WARNING]
> I have tested all modules in the script but it possibly has some tiny mistakes that I haven't found. Please inform me if you figure out issues.

## Install the latest Neovim

```bash
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xvf nvim-linux64.tar.gz
sudo mv nvim-linux64 /usr/local

# edit the .bashrc file to add 'nvim-linux64' system path
vim ~/.bashrc
# .bashrc
export PATH=/usr/local/nvim-linux64/bin:$PATH

# back to cli
source ~/.bashrc
```

## Install essential packages

```bash
sudo apt-get install -y ninja-build cmake unzip zip curl build-essential luarocks lua5.3 liblua5.3-dev npm fd-find ripgrep global sqlite3 libsqlite3-dev bat
sudo luarocks install jsregexp
```

## Install extra packages

### `Lazygit` TUI Repository Manager

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit
```

### `bat-extras` Enhanced Linux CLI Tools

```bash
git clone https://github.com/eth-p/bat-extras.git
sudo ./bat-extras/build.sh --install
rm -rf bat-extras
echo "export PATH=/usr/local/bat-extras/bin:$PATH" >>$HOME/.bashrc
source $HOME/.bashrc
```

### `Yazi` File Manager(Optional)

[\[Yazi - Installation\]](https://yazi-rs.github.io/docs/installation) tutorial provides you with the complete installation details.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
cargo install --locked yazi-fm yazi-cli
```

### System Support

- clipboard

  ```bash
  # support clipboard
  sudo apt-get install wl-clipboard
  ```

  > You can select your own clipboard support by looking at `:help clipboard-tool` in neovim.

### Formatter Support(Recommended)

- clang-format

  ```bash
  # install clang-format
  sudo apt-get install -y clang-format
  ```

- lua_ls

  ```bash
  # install lua-language-server
  LUA_LS_VERSION=$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo lua_ls.tar.gz "https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz"
  # If automatically download failed, please check <https://github.com/LuaLS/lua-language-server/releases>
  mkdir -p lua_ls
  tar xf lua_ls.tar.gz -C lua_ls
  sudo mv lua_ls /usr/local
  # add lua_ls/bin into .bashrc
  echo "export PATH=/usr/local/lua_ls/bin:$PATH" >>$HOME/.bashrc
  source $HOME/.bashrc
  ```

- python virtual environment for other LSP or formatter

  ```bash
  # select your own python-venv version
  sudo apt-get install python3.10-venv
  ```

## Add configuration files

- Move `nvim` folder into appropriate place

  ```bash
  git clone https://github.com/HangX-Ma/dotfiles.git
  mkdir ~/.config
  cp -r dotfiles/nvim ~/.config
  ```

- When you run `nvim`, **Lazy** package manager will install all neovim extensions automatically. You may encounter with some issues about a lack of dependencies. Just run the following command in neovim and follow the instructions provided by the **health report**.

  ```vim
  :checkhealth
  ```

## File Structure

```txt
nvim
├── README.md
├── assets
│   ├── nvim-main.png
│   └── nvim-statup.png
├── init.lua
├── lazy-lock.json
├── lua
│   ├── core
│   │   ├── autocmds.lua
│   │   ├── crisp.lua
│   │   ├── keybindings.lua
│   │   └── options.lua
│   ├── lazy-init.lua
│   └── plugins
│       ├── common
│       │   ├── leetcode.lua
│       │   └── rustaceanvim.lua
│       ├── debug
│       │   ├── neotest.lua
│       │   ├── nvim-dap-ui.lua
│       │   ├── nvim-dap-vtxt.lua
│       │   └── nvim-dap.lua
│       ├── editor
│       │   ├── flash.lua
│       │   ├── nvim-spider.lua
│       │   └── vim-surround.lua
│       ├── file
│       │   ├── comment.lua
│       │   ├── goto-preview.lua
│       │   ├── indent-blankline.lua
│       │   ├── markdown-preview.lua
│       │   ├── nvim-autopairs.lua
│       │   ├── nvim-bqf.lua
│       │   ├── todo-comments.lua
│       │   ├── vim-doge.lua
│       │   └── wrapping.lua
│       ├── git
│       │   ├── gitsigns.lua
│       │   └── lazygit.lua
│       ├── highlight
│       │   ├── nvim-treesitter-context.lua
│       │   ├── nvim-treesitter.lua
│       │   ├── nvim-ts-rainbow.lua
│       │   ├── python-syntax.lua
│       │   └── semshi.lua
│       ├── init.lua
│       ├── lsp
│       │   ├── auto-complete.lua
│       │   ├── formatting.lua
│       │   ├── lsp.lua
│       │   ├── navic.lua
│       │   ├── neodev.lua
│       │   ├── nvim-lint.lua
│       │   ├── server
│       │   │   ├── bash.lua
│       │   │   ├── clangd.lua
│       │   │   ├── cmake.lua
│       │   │   ├── common.lua
│       │   │   ├── lua.lua
│       │   │   ├── markdown.lua
│       │   │   └── pyright.lua
│       │   └── signature.lua
│       ├── manager
│       │   ├── bufferline.lua
│       │   ├── lualine.lua
│       │   ├── navigation.lua
│       │   ├── startup.lua
│       │   └── yazi.lua
│       ├── system
│       │   ├── clipboard.lua
│       │   ├── filetype.lua
│       │   ├── nvim-notify.lua
│       │   └── startuptime.lua
│       ├── theme
│       │   └── onedark.lua
│       └── tools
│           ├── cscope_maps.lua
│           ├── smart-open.lua
│           ├── symbols-outline.lua
│           ├── telescope.lua
│           ├── toggleterm.lua
│           ├── trouble.lua
│           └── which-key.lua
└── requirements.sh

16 directories, 68 files
```
