-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cmake
local server = {}

function server.checkOK()
	return vim.fn.executable("cmake-language-server") == 1
end

function server.setup()
	vim.lsp.enable("cmake")
end

return server
