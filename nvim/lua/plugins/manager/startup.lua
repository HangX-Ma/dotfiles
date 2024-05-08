return {
	{
		"startup-nvim/startup.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim", lazy = true },
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
		},
		config = function()
			require("startup").setup({ theme = "dashboard" })
		end,
		async = true,
	},
	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },
}
