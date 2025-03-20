return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	cmd = "Trouble",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		icons = {
			indent = {
				middle = " ",
				last = " ",
				top = " ",
				ws = "│  ",
			},
		},
		modes = {
			diagnostics = {
				groups = {
					{ "filename", format = "{file_icon} {basename:Title} {count}" },
				},
			},
			-- Diagnostics for the current buffer and errors from the current project
			mydiags = {
				mode = "diagnostics", -- inherit from diagnostics mode
				filter = {
					any = {
						buf = 0, -- current buffer
						{
							severity = vim.diagnostic.severity.ERROR, -- errors only
							-- limit to files in the current project
							function(item)
								return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
							end,
						},
					},
				},
			},
		},
	},
	config = function(_, opts)
		require("trouble").setup(opts)
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
