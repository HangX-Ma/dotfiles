-- ===== bufferline
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
vim.api.nvim_set_keymap("n", "<leader>tj", ":BufferLineCycleNext<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tk", ":BufferLineCyclePrev<CR>", {noremap = true, silent = true})
-- select a specific tab
vim.api.nvim_set_keymap("n", "<leader>ts", ":BufferLinePick<CR>", {noremap = true, silent = true})
-- close current buffer
vim.api.nvim_set_keymap("n", "<leader>td", ":bdelete %<CR>", {noremap = true, silent = true})
-- select one buffer and close it
vim.api.nvim_set_keymap("n", "<leader>tsc", ":BufferLinePickClose<CR>", {noremap = true, silent = true})
-- close all buffer other than current one
vim.api.nvim_set_keymap("n", "<leader>tco", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", {noremap = true, silent = true})
-- close left/right buffer
vim.api.nvim_set_keymap("n", "<leader>tcl", ":BufferLineCloseLeft<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>tcr", ":BufferLineCloseRight<CR>", {noremap = true, silent = true})


