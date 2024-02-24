return {
	"kawre/leetcode.nvim",
	lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
		"3rd/image.nvim",
	},
	config = function()
		require("leetcode").setup({
			arg = "leetcode.nvim",
			lang = "cpp",
			cn = { -- leetcode.cn
				enabled = true,
				translator = false,
				translate_problems = false,
			},

			injector = {
				["cpp"] = {
					before = {
						"using namespace std;",
					},
				},
			},
			description = {
				position = "left",
				width = "40%",
				show_stats = true,
			},
			image_support = false,
		})
	end,
}
