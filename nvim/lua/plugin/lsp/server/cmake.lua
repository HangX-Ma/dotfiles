-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cmake
local server = {}

function server.checkOK()
	return vim.fn.executable("cmake-language-server") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	local opts = {
		on_attach = custom_attach,
		root_dir = function(fname)
			return require("lspconfig.util").root_pattern(
				"CMakePresets.json",
				"CTestConfig.cmake",
				".git",
				"build",
				"cmake"
			)(fname)
		end,
		flags = common.lspflags,
		capabilities = common.capabilities,
		filetypes = { "cmake" },
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("cmake-language-server", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.camke.setup(opts)
	end
end

return server
