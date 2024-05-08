return {
	"EtiamNullam/deferred-clipboard.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("deferred-clipboard").setup({
			fallback = "unnamedplus", -- or your preferred setting for clipboard
			lazy = true,
		})
	end,
}
