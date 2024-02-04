
-- ===== nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- ===== bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        mode = "buffer",
        number = "ordinal", -- show id
        -- 使用 nvim 内置lsp
        diagnostics = "nvim_lsp",
        -- 左侧让出 nvim-tree 的位置
        offsets = {{
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
        }}
    }
}

-- jump between buffers
vim.api.nvim_set_keymap("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>", {noremap = true, silent = true})
-- switch to next/previous buffer
vim.api.nvim_set_keymap("n", "gt", ":BufferLineCycleNext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gT", ":BufferLineCyclePrev<CR>", {noremap = true, silent = true})
-- select a specific tab
vim.api.nvim_set_keymap("n", "<leader>tp", ":BufferLinePick<CR>", {noremap = true, silent = true})
-- close current buffer
vim.api.nvim_set_keymap("n", "<leader>bc", ":bdelete %<CR>", {noremap = true, silent = true})
-- select one buffer and close it
vim.api.nvim_set_keymap("n", "<leader>bp", ":BufferLinePickClose<CR>", {noremap = true, silent = true})
-- close all buffer other than current one
vim.api.nvim_set_keymap("n", "<leader>bo", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", {noremap = true, silent = true})


