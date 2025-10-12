local server = {}

function server.checkOK()
	return vim.fn.executable("ruff-lsp") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	local opts = {
		on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "python" },
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("ruff-lsp", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.ruff_lsp.setup(opts)
	end
end

return server
