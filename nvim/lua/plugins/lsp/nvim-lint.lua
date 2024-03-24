return {
	-- nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufWritePost",
		},
		config = function()
			require("lint").linters_by_ft = {
				markdown = { "markdownlint" },
				cpp = { "cpplint" },
				c = { "cpplint" },
				yaml = { "yamllint" },
				python = { "ruff" },
				lua = { "luacheck" },
			}
			require("lint").try_lint()
		end,
	},
	-- mason-nvim-lint
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-lint",
		},
		config = function()
			require("mason-nvim-lint").setup({
				ensure_installed = {
					"markdownlint",
					"cpplint",
					"luacheck",
					"ruff",
					"yamllint",
					"codespell",
					"commitlint",
					"checkmake",
					"cmakelang",
				},
				automatic_installation = true,
				quiet_mode = false,
			})
		end,
	},
}
