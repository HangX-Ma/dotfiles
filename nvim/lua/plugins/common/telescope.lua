return {
	"nvim-telescope/telescope.nvim",
	version = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"tsakirist/telescope-lazy.nvim",
		"catgoose/telescope-helpgrep.nvim",
	},
	init = function()
		local create_cmd = require("core.crisp").createCommand
		create_cmd("TelescopeFindFiles", function()
			require("telescope.builtin").find_files(require("telescope.themes").get_dropdown())
		end)
		create_cmd("TelescopeFindFilesNoIgnore", function()
			require("telescope.builtin").fd({ no_ignore = true })
		end)
		create_cmd("TelescopeFindFilesCWD", function()
			require("telescope.builtin").fd({ search_dirs = { vim.fn.expand("%:h") } })
		end)
		create_cmd("TelescopeLiveGrepHidden", function()
			require("telescope.builtin").live_grep({
				additional_args = { "--hidden" },
			})
		end)
	end,
	cmd = "Telescope",
	config = function()
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				-- vertical , center , cursor
				--layout_strategy = "horizontal",
				mappings = require("core.keybindings").telescopeList,
				prompt_prefix = "> ",
				selection_caret = " ",
				path_display = { truncate = 2 },
				ripgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				dynamic_preview_title = true,
				initial_mode = "insert",
				selection_strategy = "closest",
				sorting_strategy = "descending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						preview_width = 0.35,
						results_width = 0.65,
					},
					vertical = {
						mirror = false,
					},
					width = 0.9,
					height = 0.9,
					preview_cutoff = 120,
				},
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				file_ignore_patterns = { "node_modules", "\\.git" },
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				winblend = 2,
				border = {},
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				color_devicons = true,
				use_less = true,
				set_env = { ["COLORTERM"] = "truecolor" },
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
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
				help_tags = {
					mappings = {
						i = {
							["<CR>"] = actions.select_tab,
						},
						n = {
							["<CR>"] = actions.select_tab,
						},
					},
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

		local extensions = {
			"fzf",
			"lazy",
			"helpgrep",
		}

		for e in ipairs(extensions) do
			require("telescope").load_extension(extensions[e])
		end

		vim.keymap.set("n", "<leader>ff", builtin.find_files)
		vim.keymap.set("n", "<leader>fg", builtin.live_grep)
		vim.keymap.set("n", "<leader>fb", builtin.buffers)
		vim.keymap.set("n", "<leader>fh", builtin.help_tags)
	end,
}
