-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cmake
local server = {}

function server.checkOK()
	return vim.fn.executable("cmake-language-server") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local lspconfig = require("lspconfig")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.cmake.setup({
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
	})
end

return server
