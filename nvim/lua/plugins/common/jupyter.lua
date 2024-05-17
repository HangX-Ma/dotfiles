-- https://richban.tech/python-jupyter-notebooks-development-in-neo-vim
return {
	{
		"GCBallesteros/jupytext.nvim",
		dependencies = {
			"kana/vim-textobj-user",
			"kana/vim-textobj-line",
			"GCBallesteros/vim-textobj-hydrogen",
		},
		-- Depending on your nvim distro or config you may need to make the loading not lazy
		ft = { "ipynb", "markdown", "python" },
		opts = {
			style = "hydrogen",
			output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
			force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
			custom_language_formatting = {
				python = {
					extension = "md",
					style = "markdown",
					force_ft = "markdown", -- you can set whatever filetype you want here
				},
			},
		},
		config = function(_, opts)
			require("jupytext").setup(opts)
		end,
	},
	{
		"lkhphuc/jupyter-kernel.nvim",
		ft = { "ipynb", "markdown", "python" },
		opts = {
			inspect = {
				-- opts for vim.lsp.util.open_floating_preview
				window = {
					max_width = 84,
				},
			},
			-- time to wait for kernel's response in seconds
			timeout = 0.5,
		},
		cmd = { "JupyterAttach", "JupyterDetach", "JupyterInspect", "JupyterExecute" },
		build = ":UpdateRemotePlugins",
	},
}
