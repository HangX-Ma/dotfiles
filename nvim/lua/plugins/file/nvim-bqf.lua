-- The goal of nvim-bqf is to make Neovim's quickfix window better.
-- https://github.com/kevinhwang91/nvim-bqf
local opts = {
	auto_enable = true,
	auto_resize_height = true,
	key_map = {
		open = "<cr>",
		openc = "o",
		vsplit = "v",
		split = "s",
		fzffilter = "f",
		pscrollup = "<C-u>",
		pscrolldown = "<C-d>",
		ptogglemode = "F",
		filter = "n",
		filterr = "N",
	},
}

return {
	{
		"kevinhwang91/nvim-bqf",
		event = "QuickFixCmdPre",
		opts = opts,
		ft = "qf",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
	},

	{
		"ibhagwan/fzf-lua",
		dependencies = {
			-- we need to ensure the fzf has been installed
			{ "junegunn/fzf", name = "fzf", build = "./install --bin" },
			{ "nvim-web-devicons", lazy = true },
		},
		event = "VeryLazy",
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},
}
