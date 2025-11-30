return {
	-- nvim tree
	{
		"nvim-tree/nvim-tree.lua",
		version = "^v1",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 40,
				},
				update_focused_file = {
					enable = true,
					update_root = { enable = false },
				},
				renderer = { group_empty = true },
				filters = { dotfiles = true },
			})

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
			end
			local api = require("nvim-tree.api")
			-- custom mappings
			vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
			-- toggle explorer
			vim.keymap.set("n", "<C-B>", ":NvimTreeToggle<CR>", opts("Toggle Explorer"))
		end,
	},
	-- tmux
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
