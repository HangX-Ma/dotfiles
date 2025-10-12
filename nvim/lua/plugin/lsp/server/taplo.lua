local server = {}

function server.checkOK()
	return vim.fn.executable("taplo") == 1
end

function server.setup()
	vim.lsp.enable("taplo")
end

return server
