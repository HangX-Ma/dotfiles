local server = {}

function server.checkOK()
	return vim.fn.executable("rust_analyzer") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugin.lsp.server.common")
	local custom_attach = require("core.handlers").on_attach
	lspconfig.rust_analyzer.setup({
		on_attach = custom_attach,
		flags = common.lspflags,
		capabilities = vim.tbl_deep_extend("force", common.capabilities or {}, {
			experimental = {
				serverStatusNotification = true,
			},
		}),
		filetypes = { "rust" },
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
				},
				completion = {
					autoimport = {
						enable = true,
					},
					postfix = {
						enable = true,
					},
				},
				cargo = {
					allFeatures = true,
					loadOutDirsFromCheck = true,
					buildScripts = {
						enable = true,
					},
				},
				-- Add clippy lints for Rust.
				checkOnSave = {
					allFeatures = true,
					command = "clippy",
					extraArgs = { "--no-deps" },
				},
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
					},
				},
			},
		},
	})
end

return server
