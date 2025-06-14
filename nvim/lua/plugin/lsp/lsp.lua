return {
	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		opts = {
			ui = {
				icons = {
					package_installed = "√",
					package_pending = "→",
					package_uninstalled = "×",
				},
			},
			ensure_installed = {
				"codelldb",
				"black",
				"prettier",
				"clang-format",
				"clangd",
				"stylua",
				"shfmt",
				"lua-language-server",
				"cmake-language-server",
				"marksman",
				"pyright",
				"rust-analyzer",
				"taplo",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
			-- vim config
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				update_in_insert = true,
			})
			local signs = { Error = "", Warn = "", Hint = " ", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},

	-- mason lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = "williamboman/mason.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"clangd",
					"cmake",
					"lua_ls",
					"marksman",
					"rust_analyzer",
					"pyright",
					"taplo",
				},
				automatic_installation = true,
			})
		end,
	},

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"windwp/nvim-autopairs",
		},
		on_attach = function(client, bufnr)
			local status_ok, codelens_supported = pcall(function()
				return client.supports_method("textDocument/codeLens")
			end)
			if not status_ok or not codelens_supported then
				return
			end
			local group = "lsp_code_lens_refresh"
			local cl_events = { "BufEnter", "InsertLeave" }
			local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
				group = group,
				buffer = bufnr,
				event = cl_events,
			})
			if ok and #cl_autocmds > 0 then
				return
			end
			local cb = function()
				if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
					vim.lsp.codelens.refresh({ bufnr = bufnr })
				end
			end
			vim.api.nvim_create_augroup(group, { clear = false })
			vim.api.nvim_create_autocmd(cl_events, {
				group = group,
				buffer = bufnr,
				callback = cb,
			})
		end,
		config = function()
			require("lspconfig.ui.windows").default_options = {
				border = "rounded",
			}
			local crisp = require("core.crisp")
			-- Change diagnostic symbols in the sign column (gutter)
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
			local servers = {
				"bash",
				"clangd",
				"cmake",
				"lua",
				"markdown",
				"pyright",
				"taplo",
			}

			for _, server in ipairs(servers) do
				local serverModule = crisp.prequire("plugin.lsp.server." .. server)
				if serverModule and serverModule.checkOK() then
					serverModule.setup()
				else
					if crisp.notifyLSPError() then
						crisp.warn("The lsp server " .. server .. " not found", "LSP ERROR")
					end
				end
			end
		end,
	},
	-- LspUI
	{
		"jinzhongjia/LspUI.nvim",
		event = "VeryLazy",
		branch = "main",
		config = function()
			require("LspUI").setup({
				-- config options go here
			})
		end,
	},
}
