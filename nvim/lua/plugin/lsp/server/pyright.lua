-- https://www.playfulpython.com/configuring-neovim-as-a-python-ide/
local server = {}

function server.checkOK()
	return vim.fn.executable("pyright") == 1
end

function server.setup()
	vim.lsp.enable("pyright")
end

return server
