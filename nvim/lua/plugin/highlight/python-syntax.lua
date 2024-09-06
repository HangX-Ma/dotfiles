return {
	"vim-python/python-syntax",
	event = { "BufReadPre", "BufNewFile" },
	ft = { "python" },
	config = function()
        vim.g.python_version_2 = 0
        vim.b.python_version_2 = 0
		vim.g.python_highlight_all = 1
	end,
}
