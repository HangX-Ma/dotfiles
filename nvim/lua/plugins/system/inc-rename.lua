return {
	"smjonas/inc-rename.nvim",
	config = function()
		require("inc_rename").setup()
		vim.keymap.set("n", "gR", ":IncRename ")
	end,
}
