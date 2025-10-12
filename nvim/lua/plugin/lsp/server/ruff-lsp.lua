local server = {}

function server.checkOK()
	return vim.fn.executable("ruff-lsp") == 1
end

function server.setup()
	vim.lsp.enable("ruff-lsp")
end

return server
