local server = {}

function server.checkOK()
	return vim.fn.executable("taplo") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.taplo.setup({
		on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "toml" },
		single_file_support = true,
	})
end

return server
