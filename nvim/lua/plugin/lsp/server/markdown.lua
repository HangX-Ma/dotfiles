local server = {}

function server.checkOK()
	return vim.fn.executable("marksman") == 1
end

function server.setup()
	vim.lsp.enable("marksman")
end

return server
