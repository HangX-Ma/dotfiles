local function check_sqlite()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        if ! command -v sqlite3 &>/dev/null; then
            echo "Package 'sqlite3' not installed"
            echo -n "Please run 'requirements.sh' to install 'smart-open' dependencies first"
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
	"danielfalk/smart-open.nvim",
	event = "VeryLazy",
	branch = "0.2.x",
	config = function()
		require("telescope").load_extension("smart_open")
	end,
	build = function()
		check_sqlite()
	end,
	dependencies = {
		"kkharji/sqlite.lua",
		-- Only required if using match_algorithm fzf
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- Optional.  If installed, native fzy will be used when match_algorithm is fzy
		{ "nvim-telescope/telescope-fzy-native.nvim" },
	},
}
