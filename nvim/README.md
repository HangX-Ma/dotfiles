# Configure Neovim

You can follow the steps in this `README` file or read the blog [\[Start from scratch: Neovim\]](https://hangx-ma.github.io/2023/06/23/neovim-config.html).

<div class="dino" align="center">
  <table>
    <tr>
      <td><img src="./assets/nvim-statup.png" alt="Neovim: Statup Page" width=400 />
      <td><img src="./assets/nvim-main.png" alt="Neovim: Main Page" width=400 />
    </tr>
    <tr>
      <td align="center"><font size="2" color="#999"><u>Neovim: Statup Page</u></font></td>
      <td align="center"><font size="2" color="#999"><u>Neovim: Main Page</u></font></td>
    </tr>
  </table>
</div>

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

## Install extra packages

### `Yazi` File Manager(Optional)

[\[Yazi - Installation\]](https://yazi-rs.github.io/docs/installation) tutorial provides you with the complete installation details.

### System Support

- wl-clipboard

  ```bash
  sudo apt-get install wl-clipboard
  ```

### Formatter Support

- clang-format

  ```bash
  sudo apt-get install -y clang-format
  ```

- lua_ls

  ```bash
  # install clang-format
  sudo apt-get install -y clang-format
  # install lua-language-server
  # check <https://github.com/LuaLS/lua-language-server/releases> to download release file
  mkdir lua_ls
  mv lua-language-server-3.7.4-linux-x64.tar.gz lua_ls
  tar -xvf lua-language-server-3.7.4-linux-x64.tar.gz
  sudo mv lus_ls /usr/local
  # add lus_ls/bin into .bashrc
  export PATH=/usr/local/lus_ls/bin:$PATH
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
