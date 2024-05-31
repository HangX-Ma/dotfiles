-- https://richban.tech/python-jupyter-notebooks-development-in-neo-vim
return {
	{
		"lkhphuc/jupyter-kernel.nvim",
		event = "VeryLazy",
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
