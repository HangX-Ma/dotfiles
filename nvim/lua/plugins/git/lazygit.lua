local function check_lazygit()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        if ! command -v lazygit &>/dev/null; then
            echo -n "Package 'lazygit' not installed. Installing..."
            sudo add-apt-repository ppa:lazygit-team/release
            sudo apt-get update && sudo apt-get install lazygit -y
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
		"kdheepak/lazygit.nvim",
        lazy = true,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			check_lazygit()
			require("telescope").load_extension("lazygit")
		end,
	},
}
