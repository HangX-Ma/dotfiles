return {
	"Isrothy/neominimap.nvim",
	version = "v3.*.*",
	enabled = true,
	lazy = false, -- NOTE: NO NEED to Lazy load

	init = function()
		-- The following options are recommended when layout == "float"
		vim.opt.wrap = false
		vim.opt.sidescrolloff = 36 -- Set a large value

		--- Put your configuration here
		---@type Neominimap.UserConfig
		vim.g.neominimap = {
			auto_enable = true,

			float = {
                -- zindex: https://github.com/neovim/neovim/issues/18486
                -- need to be higher than 'nvim-treesiter-context'
				z_index = 11,
			},
		}
	end,
}
