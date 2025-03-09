return {
	"OXY2DEV/markview.nvim",
	lazy = true, -- Recommended
	event = { "BufReadPre" },
	-- ft = "markdown" -- If you decide to lazy-load anyway
	build = ":TSUpdate html",
	dependencies = {
		-- You will not need this if you installed the
		-- parsers manually
		-- Or if the parsers are in your $RUNTIMEPATH
		"nvim-treesitter/nvim-treesitter",

		"nvim-tree/nvim-web-devicons",
		"echasnovski/mini.nvim",
	},
}
