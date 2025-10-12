local server = {}

function server.checkOK()
	return vim.fn.executable("marksman") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	local opts = {
		on_attach = custom_attach,
		flags = common.lspflags,
		marksman = {},
		capabilities = common.capabilities,
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("marksman", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.marksman.setup(opts)
	end
end

return server
