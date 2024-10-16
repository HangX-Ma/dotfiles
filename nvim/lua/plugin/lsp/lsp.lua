return {
	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = "BufReadPre",
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
				-- "ruff-lsp",
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
		event = "BufReadPre",
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
					-- "ruff_lsp",
					"taplo",
				},
				automatic_installation = true,
			})
		end,
	},

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
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
				-- "ruff-lsp",
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

	-- lspkind
	{
		"onsails/lspkind.nvim",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local lspkind = require("lspkind")
			lspkind.init({
				-- default: true
				-- with_text = true,
				-- defines how annotations are shown
				-- default: symbol
				-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				mode = "symbol_text",
				-- default symbol map
				-- can be either 'default' (requires nerd-fonts font) or
				-- 'codicons' for codicon preset (requires vscode-codicons font)
				--
				-- default: 'default'
				preset = "codicons",
				-- override preset symbols
				--
				-- default: {}
				symbol_map = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
				},
			})
		end,
	},

	-- lspsaga
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			local lspsaga = require("lspsaga")
			lspsaga.setup({ -- defaults ...
				debug = false,
				use_saga_diagnostic_sign = true,
				-- diagnostic sign
				error_sign = "",
				warn_sign = "",
				hint_sign = "",
				infor_sign = "",
				diagnostic_header_icon = "",
				-- code action title icon
				code_action_icon = " ",
				code_action_prompt = {
					enable = true,
					sign = true,
					sign_priority = 40,
					virtual_text = true,
				},
				finder_definition_icon = "  ",
				finder_reference_icon = "  ",
				max_preview_lines = 10,
				finder_action_keys = {
					-- open = "o",
					open = "<CR>",
					vsplit = "s",
					split = "i",
					-- quit = "q",
					quit = "<ESC>",
					scroll_down = "<C-f>",
					scroll_up = "<C-b>",
				},
				code_action_keys = {
					-- quit = "q",
					quit = "<ESC>",
					exec = "<CR>",
				},
				rename_action_keys = {
					-- quit = "<C-c>",
					quit = "<ESC>",
					exec = "<CR>",
				},
				definition_preview_icon = "",
				border_style = "single",
				rename_prompt_prefix = "➤",
				rename_output_qflist = {
					enable = false,
					auto_open_qflist = false,
				},
				server_filetype_map = {},
				diagnostic_prefix_format = "%d. ",
				diagnostic_message_format = "%m %c",
				highlight_prefix = false,
				ui = {
					title = true,
					border = "rounded",
				},
				lightbulb = {
					enable = false,
				},
				symbol_in_winbar = {
					enable = false,
				},
				outline = {
					win_position = "right",
					win_with = "",
					win_width = 30,
					preview_width = 0.4,
					show_detail = true,
					auto_preview = true,
					auto_refresh = true,
					auto_close = true,
					auto_resize = false,
					custom_sort = nil,
					keys = {
						expand_or_jump = "o",
						quit = "<ESC>",
					},
				},
			})
		end,
	},
}
