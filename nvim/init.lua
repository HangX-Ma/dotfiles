require("lazy-init")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("core.autocmds")
		require("core.keybindings")
        require("syntax.c")
        require("syntax.cpp")
	end,
})

require("core.handlers").setup()
