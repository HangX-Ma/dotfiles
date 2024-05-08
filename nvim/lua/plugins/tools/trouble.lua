return {
	"folke/trouble.nvim",
    lazy = true,
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	config = function()
		local trouble = require("trouble.providers.telescope")
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<c-t>"] = trouble.open_with_trouble },
					n = { ["<c-t>"] = trouble.open_with_trouble },
				},
			},
		})
	end,
}
