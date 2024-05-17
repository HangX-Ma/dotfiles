return {
	-- python REPL: [disabled now]
	{
		"geg2102/nvim-python-repl",
		enabled = false,
		dependencies = "nvim-treesitter",
		ft = { "python", "lua", "scala" },
		config = function()
			require("nvim-python-repl").setup({
				execute_on_send = false,
				vsplit = false,
			})
		end,
	},

	-- Hydrovim: run python and display it in code editor
	{
		-- Put the cursor on the desire line of code and press F8 for running
		-- hydrovim from first line of your code to the current line and show
		-- result of the current line in the Hydrovim pop-up.
		"smzm/hydrovim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		ft = { "python" },
		config = function()
			require("hydrovim").setup()
		end,
	},
}
