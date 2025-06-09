local server = {}

function server.checkOK()
	return vim.fn.executable("marksman") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local lspconfig = require("lspconfig")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.marksman.setup({
		on_attach = custom_attach,
		marksman = {},
		flags = common.lspflags,
		capabilities = common.capabilities,
	})
end

return server
