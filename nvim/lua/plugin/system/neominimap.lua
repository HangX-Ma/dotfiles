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

			exclude_filetypes = {
				"help",
				"bigfile", -- For Snacks.nvim
				"alpha",
				"dashboard",
				"NvimTree",
				"neo-tree",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
				"Outline",
			},

			-- Minimap will not be created for buffers of these types
			exclude_buftypes = {
				"nofile",
				"nowrite",
				"quickfix",
				"terminal",
				"prompt",
			},

			layout = "float", ---@type Neominimap.Config.LayoutType

			--- Used when `layout` is set to `split`
			split = {
				minimap_width = 20, ---@type integer
				fix_width = true, ---@type boolean
				direction = "right", ---@type Neominimap.Config.SplitDirection
				close_if_last_window = true, ---@type boolean
			},

			float = {
				-- zindex: https://github.com/neovim/neovim/issues/18486
				-- need to be higher than 'nvim-treesiter-context'
				z_index = 11,
			},
		}
	end,
}
