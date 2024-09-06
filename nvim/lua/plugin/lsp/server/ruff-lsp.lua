local server = {}

function server.checkOK()
	return vim.fn.executable("ruff-lsp") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugin.lsp.server.common")
	lspconfig.ruff_lsp.setup({
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "python" },
	})
end

return server
