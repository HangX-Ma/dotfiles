return {
	"folke/trouble.nvim",
	event = "VeryLazy",
    cmd = "Trouble",
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	config = function()
        require("trouble").setup()
		local open_with_trouble = require("trouble.sources.telescope").open
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<c-t>"] = open_with_trouble },
					n = { ["<c-t>"] = open_with_trouble },
				},
			},
		})
	end,
}
