local server = {}

function server.checkOK()
	return vim.fn.executable("taplo") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugins.lsp.server.common")
	lspconfig.taplo.setup({
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "toml" },
		single_file_support = true,
	})
end

return server
