local server = {}

function server.checkOK()
	return vim.fn.executable("clangd") == 1
end

function server.setup()
	vim.lsp.enable("clangd")
end

return server
