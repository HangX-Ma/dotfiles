require("lazy-init")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("core.autocmds")
		require("core.keybindings")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	callback = function()
		require("syntax.c")
		require("syntax.cpp")
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "ReadBufPre",
	callback = function()
		require("core.handlers").setup()
	end,
})
