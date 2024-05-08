local function check_global()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        if ! command -v gtags-cscope &>/dev/null; then
            echo -n "Package 'global' not installed. Installing..."
            sudo apt-get update && sudo apt install global -y
        fi
    ]]
	local handle = io.popen("bash -c '" .. script:gsub("'", "'\\''") .. "'", "r")
	if handle ~= nil then
		local result = handle:read("*a")
		handle:close()
		if result ~= nil and result ~= "" then
			crisp.notify(result, "info", "Installing result")
		end
	end
end

return {
	{
		"dhananjaylatkar/cscope_maps.nvim",
		dependencies = {
			"folke/which-key.nvim", -- optional [for whichkey hints]
			{ "nvim-telescope/telescope.nvim", lazy = true }, -- optional [for picker="telescope"]
			"ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
			{ "nvim-tree/nvim-web-devicons", lazy = true }, -- optional [for devicons in telescope or fzf]
			"rcarriga/nvim-notify",
		},
		-- only matched patterns will load this extension
		event = { "BufRead *.cpp *.c *.s *.S" },
		opts = {
			-- USE EMPTY FOR DEFAULT OPTIONS
			-- DEFAULTS ARE LISTED BELOW

			-- maps related defaults
			disable_maps = false, -- "true" disables default keymaps
			skip_input_prompt = false, -- "true" doesn't ask for input
			prefix = "<leader>c", -- prefix to trigger maps

			-- cscope related defaults
			cscope = {
				-- location of cscope db file
				db_file = "./cscope.out", -- DB or table of DBs
				-- NOTE:
				--   when table of DBs is provided -
				--   first DB is "primary" and others are "secondary"
				--   primary DB is used for build and project_rooter
				--   secondary DBs must be built with absolute paths
				--   or paths relative to cwd. Otherwise JUMP will not work.
				-- cscope executable
				exec = "gtags-cscope", -- "cscope" or "gtags-cscope"
				-- choose your fav picker
				picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
				-- size of quickfix window
				qf_window_size = 5, -- any positive integer
				-- position of quickfix window
				qf_window_pos = "bottom", -- "bottom", "right", "left" or "top"
				-- "true" does not open picker for single result, just JUMP
				skip_picker_for_single_result = false, -- "false" or "true"
				-- these args are directly passed to "cscope -f <db_file> <args>"
				db_build_cmd_args = { "-bqkv" },
				-- statusline indicator, default is cscope executable
				statusline_indicator = nil,
				-- try to locate db_file in parent dir(s)
				project_rooter = {
					enable = false, -- "true" or "false"
					-- change cwd to where db_file is located
					change_cwd = false, -- "true" or "false"
				},
			},
		},
		config = function(_, opts)
			check_global()
			require("cscope_maps").setup(opts)
		end,
	},

	-- gtags/ctags/gtags-cscope
	-- reference: https://zhuanlan.zhihu.com/p/36279445
	{
		"ludovicchabant/vim-gutentags",
		event = { "BufRead *.cpp *.c *.s *.S", "BufNewFile *.cpp *.c *.s *.S" },
		init = function()
			-- Or use 'Cs db build' manually!!!
			vim.g.gutentags_project_root = { ".root", ".svn", ".git", ".hg", ".project" }
			vim.g.gutentags_modules = { "cscope_maps" } -- This is required. Other config is optional
			vim.g.gutentags_cscope_build_inverted_index_maps = 1
			vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/.gutentags")
			vim.g.gutentags_file_list_command = "fd -e c -e h"
			vim.g.gutentags_ctags_extra_args = {
				"--fields=+niazS",
				"--c++-kinds=+px",
				"--c-kinds=+px",
			}
			-- vim.g.gutentags_trace = 1
		end,
	},
}
