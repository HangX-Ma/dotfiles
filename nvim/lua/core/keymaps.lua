-- set vim leader to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- ---------- Usage Description ----------
-- <C-?> means 'ctrl + ?'
-- <A-?> means 'alt + ?'
-- ---------------------------------------

-- visual line
-- no highlight
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- nvim-tree
-- toogle explorer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- split windows vertically or horizontally
keymap.set("n", "<leader>sv", ":vsp<CR>")
keymap.set("n", "<leader>sh", ":sp<CR>")

-- close current window <C-w>c
-- close other window <C-w>o

-- indent code in 'Normal Mode'
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- move code up or down in 'Normal Mode'
keymap.set("v", "<A-Up>", ":move '<-2<CR>gv-gv")
keymap.set("v", "<A-Down>", ":move '>+1<CR>gv-gv")

-- 左右比例控制
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")
-- 上下比例
keymap.set("n", "<C-Down>", ":resize +2<CR>")
keymap.set("n", "<C-Up>", ":resize -2<CR>")
-- 等比例 <C-w>=
