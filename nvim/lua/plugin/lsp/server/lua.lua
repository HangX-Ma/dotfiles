-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local server = {}

function server.checkOK()
	return vim.fn.executable("lua-language-server") == 1
end

function server.setup()
	vim.lsp.enable("lua_ls")
end

return server
