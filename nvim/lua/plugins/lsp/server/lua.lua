-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local server = {}
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local common = require("plugins.lsp.server.common")

local opts = {
	capabilities = common.capabilities,
	on_attach = function(bufnr)
		common.keybindings(bufnr)
	end,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
			},
		},
	},

	-- custom handler
	-- handlers = {
	--   ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	--     virtual_text = false,
	--     signs = true,
	--     underline = true,
	--     update_in_insert = false,
	--   }),
	-- },
}

function server.checkOK()
	return vim.fn.executable("lua-language-server") == 1
end

function server.setup()
	common.lspconfig.lua_ls.setup(opts)
end

return server
