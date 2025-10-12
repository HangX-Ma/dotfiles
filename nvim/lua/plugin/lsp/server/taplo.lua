local server = {}

function server.checkOK()
	return vim.fn.executable("taplo") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	local opts = {
		on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "toml" },
		single_file_support = true,
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("taplo", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.taplo.setup(opts)
	end
end

return server
