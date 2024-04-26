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
	"kevinhwang91/nvim-bqf",
	opts = opts,
	ft = "qf",
	dependencies = {
		"ibhagwan/fzf-lua",
		build = function()
			vim.fn["fzf#install"]()
		end,
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},
}
