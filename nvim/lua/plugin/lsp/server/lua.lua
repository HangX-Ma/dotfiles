-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local server = {}

function server.checkOK()
	return vim.fn.executable("lua-language-server") == 1
end

function server.setup()
	-- lazydev.nvim configuration
	-- https://www.reddit.com/r/neovim/comments/1d5ub7d/lazydevnvim_much_faster_luals_setup_for_neovim/
	local opts = {
		settings = {
			Lua = {
				hint = {
					enable = true, -- necessary
				},
			},
		},
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("lua-language-server", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup(opts)
	end
end

return server
