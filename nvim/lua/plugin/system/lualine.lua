local function virtlocation()
	local line = vim.fn.line('.')
	local vcol = vim.fn.virtcol('.')
	return string.format("%d:%d", line, vcol)
end

-- status bar
return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = false },
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	config = function()
		-- local navic = require("nvim-navic")
		local config = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {
						"",
						"help",
						"alpha",
						"dashboard",
						"NvimTree",
						"neo-tree",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lazyterm",
						"neominimap",
					},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { virtlocation, { "datetime", style = " %H:%M" } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { virtlocation, { "datetime", style = " %H:%M" } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {
				--[[ lualine_c = {
					{
						function()
							return navic.get_location()
						end,
						cond = function()
							return navic.is_available()
						end,
					},
				}, ]]
			},
			inactive_winbar = {},
			extensions = {},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
 				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " LSP:",
			color = { fg = "#eeeeee", gui = "bold" },
		})

		-- Now don't forget to initialize lualine
		require("lualine").setup(config)
	end,
}
