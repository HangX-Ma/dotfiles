-- https://github.com/numirias/semshi

local function check_utils()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash

        # check python3 status
        if ! command -v python3 &>/dev/null; then
            echo -n "Package 'python3' not installed. Installing..."
            sudo apt-get update && sudo apt install python3 -y
        fi

        # check pynvim status
        if ! python3 -m pip list | grep pynvim &>/dev/null; then
            echo -n "Module 'pynvim' not installed. Installing..."
            python3 -m pip -H install pynvim --upgrade &>/dev/null
            if [ $? -eq 0 ]; then
                echo "Successfully install module 'pynvim'"
            else
                echo "Install 'pynvim' failed. Please check 'python3' and 'pip' module"
            fi
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
	-- "numiras/semshi",
	"wookayin/semshi", -- use a maintained fork
	ft = "python",
	version = "*", -- Recommended to use the latest release
	event = { "BufReadPre", "BufNewFile" },
	build = ":UpdateRemotePlugins",
	init = function()
		-- Disabled these features better provided by LSP or other more general plugins
		vim.g["semshi#error_sign"] = false
		vim.g["semshi#simplify_markup"] = false
		vim.g["semshi#mark_selected_nodes"] = false
		vim.g["semshi#update_delay_factor"] = 0.001

		-- This autocmd must be defined in init to take effect
		vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
			group = vim.api.nvim_create_augroup("SemanticHighlight", {}),
			callback = function()
				-- Only add style, inherit or link to the LSP's colors
				vim.cmd([[
            highlight! link semshiGlobal  @none
            highlight! link semshiImported @none
            highlight! link semshiParameter @lsp.type.parameter
            highlight! link semshiBuiltin @function.builtin
            highlight! link semshiAttribute @field
            highlight! link semshiSelf @lsp.type.selfKeyword
            highlight! link semshiUnresolved @none
            highlight! link semshiFree @none
            highlight! link semshiAttribute @none
            highlight! link semshiParameterUnused @none
            ]])
			end,
		})
	end,
	config = function()
		-- any config or setup that would need to be done after plugin loading
		check_utils()
	end,
	enabled = false,
}
