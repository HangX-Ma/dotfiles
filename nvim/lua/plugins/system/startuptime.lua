return {
	-- measure startuptime
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		lazy = true,
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
