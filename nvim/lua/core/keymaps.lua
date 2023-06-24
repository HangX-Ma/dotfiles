-- set vim leader to <space>
vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------- Usage Description ----------
-- <C-?> means 'ctrl + ?'
-- <A-?> means 'alt + ?'
-- ---------------------------------------

-- visual line
keymap.set("n", "<leader>nh", ":nohl<CR>") -- no highlight

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toogle explorer

-- customize key mappings: <https://juejin.cn/book/7051157342770954277/section/7051536642238054430>

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


-- Vimspector keymappings
keymap.set("n", "<S-Right>", ":bnext<CR>")
keymap.set("n", "<S-Left>", ":bprevious<CR>")

vim.cmd([[
nmap <F5> <cmd>call vimspector#StepOver()<cr>
nmap <F8> <cmd>call vimspector#Reset()<cr>
nmap <F9> <cmd>call vimspector#Launch()<cr>
nmap <F10> <cmd>call vimspector#StepInto()<cr>")
nmap <F11> <cmd>call vimspector#StepOver()<cr>")
nmap <F12> <cmd>call vimspector#StepOut()<cr>")
]])
keymap.set('n', "Db", ":call vimspector#ToggleBreakpoint()<cr>")
keymap.set('n', "Dw", ":call vimspector#AddWatch()<cr>")
keymap.set('n', "De", ":call vimspector#Evaluate()<cr>")

-- 左右比例控制
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")
-- 上下比例
keymap.set("n", "<C-Down>", ":resize +2<CR>")
keymap.set("n", "<C-Up>", ":resize -2<CR>")
-- 等比例 <C-w>=