return {
	"nvim-telescope/telescope.nvim",
	version = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		require("telescope").setup({
			defaults = {
				initial_mode = "insert",
				-- vertical , center , cursor
				--layout_strategy = "horizontal",
				mappings = require("core.keybindings").telescopeList,
			},
			pickers = {
				find_files = {
					--theme = "dropdown", -- optional: dropdown, cursor, ivy
					preview = true,
				},
				live_grep = {
					-- theme = "ivy",
					preview = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
		})
		vim.keymap.set("n", "<leader>ff", builtin.find_files)
		vim.keymap.set("n", "<leader>fg", builtin.live_grep)
		vim.keymap.set("n", "<leader>fb", builtin.buffers)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags)
	end,
}
