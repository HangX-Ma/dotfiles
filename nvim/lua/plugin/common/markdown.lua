return {
	"MeanderingProgrammer/render-markdown.nvim",
	lazy = true,
	event = { "BufReadPre" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
	---@module 'render-markdown'
	---@type render.md.UserConfig
	config = function()
		require("render-markdown").setup({
			completions = {
				lsp = { enabled = true },
				blink = { enabled = true },
			},
		})

		local cmp = require("cmp")
		cmp.setup({
			sources = cmp.config.sources({
				{ name = "render-markdown" },
			}),
		})
	end,
}
