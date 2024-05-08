local function check_lazygit()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        if ! command -v lazygit &>/dev/null; then
            echo "Package 'lazygit' not installed"
            echo -n "Please run 'requirements.sh' first"
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
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		lazy = true,
		build = function()
			check_lazygit()
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},
}
