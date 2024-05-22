return {
	"kkoomen/vim-doge",
	event = { "BufReadPre", "BufNewFile" },
	build = function()
		vim.fn["doge#install"]()
	end,
}
