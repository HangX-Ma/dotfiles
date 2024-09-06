return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "black" },
				bash = { "shfmt"  },
				cmake = { "cmake" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				-- Use the "*" filetype to run formatters on all filetypes.
			},
			-- format on save
			--[[ format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			}, ]]
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.WARNNING,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
		})

		vim.keymap.set({ "n", "v" }, "<leader>fm", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range" })
	end,
}
