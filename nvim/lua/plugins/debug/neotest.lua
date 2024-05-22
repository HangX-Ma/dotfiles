return {
	"nvim-neotest/neotest",
    lazy = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- adapter
		"nvim-neotest/neotest-python",
		"rouge8/neotest-rust",
		"alfaix/neotest-gtest",
	},
	config = function()
		require("neotest").setup({
			require("neotest-python")({
				dap = { justMyCode = false },
			}),
			require("neotest-rust")({
				args = { "--no-capture" },
				dap_adapter = "codelldb",
			}),
			require("neotest-gtest"),
		})
	end,
}
