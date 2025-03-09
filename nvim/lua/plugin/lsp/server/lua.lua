-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local server = {}

function server.checkOK()
	return vim.fn.executable("lua-language-server") == 1
end

function server.setup()
	-- lazydev.nvim configuration
	-- https://www.reddit.com/r/neovim/comments/1d5ub7d/lazydevnvim_much_faster_luals_setup_for_neovim/
	local lspconfig = require("lspconfig")
	lspconfig.lua_ls.setup({
		root_dir = lspconfig.util.root_pattern(
			"init.lua",
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",
			".stylua.toml",
			"stylua.toml",
			"selene.toml",
			"selene.yml",
			".git"
		),
	})

	-- no need for lazydev.nvim
	--[[ local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	local lspconfig = require("lspconfig")
	lspconfig.lua_ls.setup({
        on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = common.capabilities,
        before_init = require("neodev.nvim").before_init,
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				client.config.settings = vim.tbl_deep_extend("force", client.config.settings.Lua, {
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
				})

				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			end
			return true
		end,
	}) ]]
end

return server
