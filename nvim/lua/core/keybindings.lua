-- set vim leader to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ---------- Usage Description ----------
-- <C-?> means 'ctrl + ?'
-- <A-?> means 'alt + ?'
-- ---------------------------------------

keymap.set("i", "<C-[>", "<ESC>", opts)
keymap.set("n", "<leader>q", ":q!<CR>", opts)
keymap.set("n", "<leader>Q", ":qa!<CR>", opts)
keymap.set("n", "<leader>x", ":x<CR>", opts)
keymap.set("n", "<leader>X", ":xa<CR>", opts)

-- visual line
-- no highlight
keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

-- split windows vertically or horizontally
keymap.set("n", "<leader>sv", ":vsp<CR>", opts)
keymap.set("n", "<leader>sh", ":sp<CR>", opts)

-- close current window <C-w>c
-- close other window <C-w>o

-- indent code in 'Normal Mode'
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- move code up or down in 'Normal Mode'
keymap.set("v", "J", ":move '>+1<CR>gv-gv", opts)
keymap.set("v", "K", ":move '<-2<CR>gv-gv", opts)

-- control window left/right size
keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- control window up/down size
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)

-- equivalent scale: <C-w>=

-- ------------- extensions -------------
local pluginKeys = {}
-- toogle explorer
keymap.set("n", "<C-N>", ":NvimTreeToggle<CR>", opts)

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
