local server = {}

function server.checkOK()
	return vim.fn.executable("ruff-lsp") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.ruff_lsp.setup({
		on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "python" },
	})
end

return server
