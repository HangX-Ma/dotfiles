-- set vim leader to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap
local opt = { noremap = true, silent = true }

-- ---------- Usage Description ----------
-- <C-?> means 'ctrl + ?'
-- <A-?> means 'alt + ?'
-- ---------------------------------------

keymap.set("i", "<C-[>", "<ESC>", opt)

-- visual line
-- no highlight
keymap.set("n", "<leader>nh", ":nohl<CR>", opt)

-- split windows vertically or horizontally
keymap.set("n", "<leader>sv", ":vsp<CR>", opt)
keymap.set("n", "<leader>sh", ":sp<CR>", opt)

-- close current window <C-w>c
-- close other window <C-w>o

-- indent code in 'Normal Mode'
keymap.set("v", "<", "<gv", opt)
keymap.set("v", ">", ">gv", opt)

-- move code up or down in 'Normal Mode'
keymap.set("v", "J", ":move '>+1<CR>gv-gv", opt)
keymap.set("v", "K", ":move '<-2<CR>gv-gv", opt)

-- control window left/right size
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", opt)
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", opt)

-- control window up/down size
keymap.set("n", "<C-Down>", ":resize +2<CR>", opt)
keymap.set("n", "<C-Up>", ":resize -2<CR>", opt)

-- equivalent scale: <C-w>=

-- ------------- extensions -------------
local pluginKeys = {}
-- toogle explorer
keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", opt)

-- treesitter folder
keymap.set('n', 'zz', ':foldclose<CR>', opt)
keymap.set('n', 'Z', ':foldopen<CR>', opt)

-- lsp callbackfunction
pluginKeys.mapLSP = function(mapbuf)
  mapbuf('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opt)
  mapbuf('n', 'cm', '<cmd>Lspsaga rename<CR>', opt)
  mapbuf('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opt)
  mapbuf('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', opt)
  mapbuf('n', 'gD', '<cmd>Lspsaga peek_definition<CR>', opt)
  mapbuf('n', 'gt', '<cmd>Lspsaga peek_definition<CR>', opt)
  mapbuf('n', 'gh', '<cmd>Lspsaga hover_doc<cr>', opt)
  mapbuf('n', 'gr', '<cmd>Lspsaga lsp_finder<CR>', opt)
  mapbuf('n', 'gp', '<cmd>Lspsaga show_line_diagnostics<CR>', opt)
  mapbuf('n', 'gj', '<cmd>Lspsaga diagnostic_jump_next<CR>', opt)
  mapbuf('n', 'gk', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opt)
  mapbuf('n', '<F8>', '<cmd>Lspsaga outline<CR>', opt)
end

return pluginKeys
