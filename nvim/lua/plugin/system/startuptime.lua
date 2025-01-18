return {
	-- measure startuptime
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
        enabled = false,
		lazy = true,
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
