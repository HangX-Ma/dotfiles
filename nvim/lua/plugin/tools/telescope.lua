local function live_grep_cbd()
	require("telescope.builtin").live_grep({
		cwd = require("telescope.utils").buffer_dir(),
	})
end

local function live_grep_cwd()
	require("telescope.builtin").live_grep({
		cwd = vim.fn.getcwd(),
	})
end

local function live_grep_files()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
	})
end

local function grep_string_cwd()
	require("telescope.builtin").grep_string({
		cwd = vim.fn.getcwd(),
	})
end

local function grep_string_cbd()
	require("telescope.builtin").grep_string({
		cwd = require("telescope.utils").buffer_dir(),
	})
end

local function grep_string_files()
	require("telescope.builtin").grep_string({
		grep_open_files = true,
	})
end

local function check_utils()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        package_installed=true
        if ! command -v fdfind &>/dev/null; then
            echo "Package 'fd-find' not installed"
            package_installed=false
        fi
        if ! command -v rg &>/dev/null; then
            echo "Package 'ripgrep' not installed"
            package_installed=false
        fi
        if ! command -v batcat &>/dev/null; then
            echo "Package 'bat' not installed"
            package_installed=false
        fi

        if "$package_installed" = false; then
            echo -n "Please run 'requirements.sh' to install 'telescope' dependencies first"
        fi
    ]]
	local handle = io.popen("bash -c '" .. script:gsub("'", "'\\''") .. "'", "r")
	if handle ~= nil then
		local result = handle:read("*a")
		handle:close()
		if result ~= nil and result ~= "" then
			crisp.notify(result, "error", "Package state checker information")
		end
	end
end

return {
	"nvim-telescope/telescope.nvim",
	version = "0.1.x",
	event = { "VeryLazy" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-symbols.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"catgoose/telescope-helpgrep.nvim",
	},
	cmd = "Telescope",
	build = function()
		check_utils()
	end,
	keys = {
		-- find files
		{ "<leader>fg", live_grep_files, desc = "Grep in open files" },
		{ "<leader>fsw", grep_string_files, desc = "Search word in open files" },
		-- search
		{ "<leader>fsa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>fsb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>fsc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>fsC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>fsd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>fsg", live_grep_cwd, desc = "Grep(CWD)" },
		{ "<leader>fsG", live_grep_cbd, desc = "Grep(Buffer)" },
		{ "<leader>fsj", "<cmd>Telescope jumplist<CR>", desc = "Jumplist" },
		{ "<leader>fsk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
		{ "<leader>fsm", "<cmd>Telescope marks<CR>", desc = "Jump to Marks" },
		{ "<leader>fsM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
		{ "<leader>fso", "<cmd>Telescope vim_options<CR>", desc = "Vim Options" },
		{ "<leader>fsq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
		{ "<leader>fst", "<cmd>Telescope<CR>", desc = "Telescope Builtins" },
		{ "<leader>fsT", "<cmd>Telescope tags<CR>", desc = "Tags" },
		{ "<leader>fss", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
		{ "<leader>fsS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Workspace Symbols" },
		{ "<leader>fsw", grep_string_cwd, desc = "Word(CWD)" },
		{ "<leader>fsW", grep_string_cbd, desc = "Word(Buffer)" },
	},
	config = function()
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
				-- note: remove the 'builtin.' prefix.
				find_files = {
					theme = "dropdown", -- optional: dropdown, cursor, ivy
					preview = true,
					wrap_results = true,
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
				-- reference: https://codeberg.org/artfulrobot/nvim-config/src/branch/lazy/lua/plugins/telescope.lua
				lsp_references = { wrap_results = true },
				lsp_definitions = { wrap_results = true },
				diagnostics = { wrap_results = true },
				buffers = { sort_mru = true, ignore_current_buffer = true },
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						-- even more opts
					}),
				},
			},
		})

		local extensions = {
			"fzf",
			"helpgrep",
			"file_browser",
			"ui-select",
			"dap",
		}

		for e in ipairs(extensions) do
			require("telescope").load_extension(extensions[e])
		end
	end,
}
