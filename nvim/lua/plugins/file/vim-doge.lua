return {
	"kkoomen/vim-doge",
	event = { "BufReadPre", "BufNewFile" },
	build = function()
		vim.fn["doge#install"]()
	end,
	config = function()
		vim.keymap.set("n", "<Leader>x", "<Plug>(doge-generate)")

		-- Interactive mode comment todo-jumping
		vim.keymap.set("n", "<TAB>", "<Plug>(doge-comment-jump-forward)")
		vim.keymap.set("n", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")
		vim.keymap.set("i", "<TAB>", "<Plug>(doge-comment-jump-forward)")
		vim.keymap.set("i", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")
		vim.keymap.set("x", "<TAB>", "<Plug>(doge-comment-jump-forward)")
		vim.keymap.set("x", "<S-TAB>", "<Plug>(doge-comment-jump-backward)")

		-- open doxygen syntax highlight
		vim.g.load_doxygen_syntax = 1
	end,
}
