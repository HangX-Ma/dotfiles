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
keymap.set("n", "<leader>q", ":q!<CR>", opt)
keymap.set("n", "<leader>Q", ":qa!<CR>", opt)
keymap.set("n", "<leader>x", ":x<CR>", opt)
keymap.set("n", "<leader>X", ":xa<CR>", opt)

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
keymap.set("n", "<C-N>", ":NvimTreeToggle<CR>", opt)

-- <leader>tt float
-- <leader>tv vertical
-- <leader>th horizontal
pluginKeys.mapToggleTerm = function(toggleterm)
	vim.keymap.set({ "n", "t" }, "tf", toggleterm.toggleFloat)
	vim.keymap.set({ "n", "t" }, "tv", toggleterm.toggleVertical)
	vim.keymap.set({ "n", "t" }, "th", toggleterm.toggleHorizontal)
end

pluginKeys.telescopeList = {
	i = {
		["<C-j>"] = "move_selection_next",
		["<C-k>"] = "move_selection_previous",
		["<C-n>"] = "move_selection_next",
		["<C-p>"] = "move_selection_previous",
		["<Down>"] = "cycle_history_next",
		["<Up>"] = "cycle_history_prev",
		["<C-c>"] = "close",
		["<C-u>"] = "preview_scrolling_up",
		["<C-d>"] = "preview_scrolling_down",
	},
}

return pluginKeys
