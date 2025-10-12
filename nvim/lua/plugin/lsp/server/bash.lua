local server = {}

function server.checkOK()
	return vim.fn.executable("bash-language-server") == 1
end

function server.setup()
	vim.lsp.enable("bashls")
end

return server
