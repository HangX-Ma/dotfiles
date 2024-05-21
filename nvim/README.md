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

## System Support(Recommended)

- clipboard

  ```bash
  # support clipboard
  sudo apt-get install wl-clipboard
  ```

  > You can select your own clipboard support by looking at `:help clipboard-tool` in neovim.

## Update configuration files

- Move `nvim` folder into appropriate place or use the script to update configuration.

  ```bash
  git clone https://github.com/HangX-Ma/dotfiles.git
  mkdir ~/.config
  cp -r dotfiles/nvim ~/.config
  ```

- When you run `nvim`, **Lazy** package manager will install all neovim extensions automatically. You may encounter with some issues about a lack of dependencies. Just run the following command in neovim and follow the instructions provided by the **health report**.

  ```vim
  :checkhealth
  ```

## Structure

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
│       │   ├── jupyter.lua
│       │   ├── leetcode.lua
│       │   ├── python.lua
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
│       │   └── nvim-ts-rainbow.lua
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
│           ├── which-key.lua
│           └── yarepl.lua
└── requirements.sh

16 directories, 69 files
```

- **DAP**: c, cpp, python, rust, lua
- **LSP**: c, cpp, python, rust, lua, cmake, bash, markdown, vim
- **Lint**: c, cpp, python, lua, markdown, yaml
- **Formater**: c, cpp, python, lua, cmake, bash, markdown, yaml, json, html, css, javascript, typescript, javascriptreact, typescriptreact, svelte, graphql
