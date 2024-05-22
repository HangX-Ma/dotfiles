-- https://www.josean.com/posts/neovim-linting-and-formatting
return {
	-- nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufWritePost",
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				cpp = { "cpplint" },
				c = { "cpplint" },
				yaml = { "yamllint" },
				python = { "ruff" },
				lua = { "luacheck" },
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            -- configure cpplint
            --ref: https://github.com/google/styleguide/blob/gh-pages/cpplint/cpplint.py
            local cpplint = lint.linters.cpplint
            cpplint.args = {
                '--filter=-whitespace/braces,-whitespace/line_length,-legal/copyright,-build/c++11',
            }
            local cpplint_ns = lint.get_namespace("cpplint")
            vim.diagnostic.config({ virtual_text = true }, cpplint_ns)

            -- configure luacheck
            local luacheck = lint.linters.luacheck
            luacheck.args = {
                "--globals vim"
            }

            -- trigger lint
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
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
