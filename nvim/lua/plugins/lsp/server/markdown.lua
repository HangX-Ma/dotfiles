local server = {}

function server.checkOK()
	return vim.fn.executable("marksman") == 1
end

function server.setup()
	local common = require("plugins.lsp.server.common")
	local lspconfig = require("lspconfig")
	lspconfig.marksman.setup({
		marksman = {},
		flags = common.lspflags,
		capabilities = common.capabilities,
	})
end

return server
