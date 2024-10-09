return {
	"olimorris/onedarkpro.nvim",
	enabled = true,
	lazy = false,
	priority = 1000,
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme onedark]])
	end,
}
