-- https://www.playfulpython.com/configuring-neovim-as-a-python-ide/
local server = {}

function server.checkOK()
	return vim.fn.executable("pyright") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.pyright.setup({
        	on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "python" },
	})
end

return server
