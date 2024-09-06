return {
	"rmagatti/goto-preview",
	event = { "BufReadPre", "BufNewFile" },
    lazy = false,
	config = function()
		require("goto-preview").setup({
			width = 120,
			height = 25,
			default_mappings = false, -- Bind default mappings
			debug = false,
			opacity = nil,
			post_open_hook = nil,
		})
	end,
}
