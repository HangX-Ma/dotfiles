-- This plugin is no longer needed as the optimization has been merged into Neovim core.
-- It is only here for archival purposes.
return {
	"nathom/filetype.nvim",
	enabled = false,
	config = function()
		-- In init.lua or filetype.nvim's config file
		require("filetype").setup({
			overrides = {
				extensions = {
					-- Set the filetype of *.pn files to potion
					pn = "potion",
				},
				literal = {
					-- Set the filetype of files named "MyBackupFile" to lua
					MyBackupFile = "lua",
				},
				complex = {
					-- Set the filetype of any full filename matching the regex to gitconfig
					[".*git/config"] = "gitconfig", -- Included in the plugin
				},

				-- The same as the ones above except the keys map to functions
				function_extensions = {
					["pl"] = function()
						vim.bo.filetype = "perl"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["s"] = function()
						vim.bo.filetype = "asm"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["S"] = function()
						vim.bo.filetype = "asm"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["cpp"] = function()
						vim.bo.filetype = "cpp"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["c"] = function()
						vim.bo.filetype = "c"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["h"] = function()
						vim.bo.filetype = "cpp"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["sh"] = function()
						vim.bo.filetype = "bash"
						-- Remove annoying indent jumping
						vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
					end,
					["pdf"] = function()
						vim.bo.filetype = "pdf"
						-- Open in PDF viewer (Skim.app) automatically
						vim.fn.jobstart("open -a skim " .. '"' .. vim.fn.expand("%") .. '"')
					end,
				},
				function_literal = {
					Brewfile = function()
						vim.cmd("syntax off")
					end,
				},
				function_complex = {
					["*.math_notes/%w+"] = function()
						vim.cmd("iabbrev $ $$")
					end,
				},

				shebang = {
					-- Set the filetype of files with a dash shebang to sh
					dash = "sh",
				},
			},
		})
	end,
}
