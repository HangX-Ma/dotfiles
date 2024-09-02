return {
	"esensar/nvim-dev-container",
	enabled = false,
	dependencies = "nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	config = function()
		require("devcontainer").setup({})
	end,
}
