local function check_utils()
	local crisp = require("core.crisp")
	local script = [[
        #!/bin/bash
        package_installed=true
        if ! python3 -m list | grep pynvim &>/dev/null; then
            echo "python module 'pynvim' not installed"
            package_installed=false
        fi

        if ! python3 -m list | grep jupyter &>/dev/null; then
            echo "python module 'jupyter' not installed"
            package_installed=false
        fi

        if ! python3 -m list | grep jupytext &>/dev/null; then
            echo "python module 'jupytext' not installed"
            package_installed=false
        fi

        if ! python3 -m list | grep ilua &>/dev/null; then
            echo "python module 'ilua' not installed"
            package_installed=false
        fi

        if "$package_installed" = false; then
            echo -n "Please run 'requirements.sh' to install 'REPL' dependencies first"
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
	"milanglacier/yarepl.nvim",
	event = { "BufRead *.py *.sh *.ipy", "BufNewFile *.py *.sh *.ipy" },
	enabled = true,
	cmd = {
		"REPLStart",
		"REPLAttachBufferToREPL",
		"REPLDetachBufferToREPL",
		"REPLCleanup",
		"REPLFocus",
		"REPLHide",
		"REPLClose",
		"REPLSwap",
		"REPLSendVisual",
		"REPLSendLine",
		"REPLSendMotion",
	},
	build = function()
		check_utils()
	end,
	config = function()
		local yarepl = require("yarepl")
		yarepl.setup({
			-- see `:h buflisted`, whether the REPL buffer should be buflisted.
			buflisted = true,
			-- whether the REPL buffer should be a scratch buffer.
			scratch = true,
			-- the filetype of the REPL buffer created by `yarepl`
			ft = "REPL",
			wincmd = function(bufnr, name)
				if vim.g.REPL_use_floatwin == 1 then
					vim.api.nvim_open_win(bufnr, true, {
						relative = "editor",
						row = math.floor(vim.o.lines * 0.25),
						col = math.floor(vim.o.columns * 0.25),
						width = math.floor(vim.o.columns * 0.5),
						height = math.floor(vim.o.lines * 0.5),
						style = "minimal",
						title = name,
						border = "rounded",
						title_pos = "center",
					})
				else
					vim.cmd([[belowright 15 split]])
					vim.api.nvim_set_current_buf(bufnr)
				end
			end,
			metas = {
				aichat = { cmd = "aichat", formatter = yarepl.formatter.bracketed_pasting },
				radian = { cmd = "radian", formatter = yarepl.formatter.bracketed_pasting },
				ipython = { cmd = "ipython", formatter = yarepl.formatter.bracketed_pasting },
				python = { cmd = "python", formatter = yarepl.formatter.trim_empty_lines },
				R = { cmd = "R", formatter = yarepl.formatter.trim_empty_lines },
				bash = { cmd = "bash", formatter = yarepl.formatter.trim_empty_lines },
				zsh = { cmd = "zsh", formatter = yarepl.formatter.bracketed_pasting },
			},
			-- when a REPL process exits, should the window associated with those REPLs closed?
			close_on_exit = true,
			-- whether automatically scroll to the bottom of the REPL window after sending
			-- text? This feature would be helpful if you want to ensure that your view
			-- stays updated with the latest REPL output.
			scroll_to_bottom_after_sending = true,
			os = {
				-- Some hacks for Windows. macOS and Linux users can simply ignore
				-- them. The default options are recommended for Windows user.
				windows = {
					-- Send a final `\r` to the REPL with delay,
					send_delayed_cr_after_sending = true,
				},
			},
		})

		require("telescope").load_extension("REPLShow")

		vim.g.REPL_use_floatwin = 0
	end,
}
