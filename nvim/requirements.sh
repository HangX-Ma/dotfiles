#!/bin/bash

# install basic packages
sudo apt-get update
sudo apt-get install -y ninja-build cmake unzip zip curl build-essential luarocks lua5.3 npm fd-find ripgrep global sqlite3 libsqlite3-dev bat
sudo luarocks install jsregexp

# install lazygit
if ! command -v lazygit --version&>/dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
fi

