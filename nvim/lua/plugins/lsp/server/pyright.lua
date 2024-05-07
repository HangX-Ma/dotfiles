-- https://www.playfulpython.com/configuring-neovim-as-a-python-ide/
local server = {}

function server.checkOK()
	return vim.fn.executable("pyright") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugins.lsp.server.common")
	lspconfig.bashls.setup({
		flags = common.lspflags,
		capabilities = common.capabilities,
	})
end

return server
