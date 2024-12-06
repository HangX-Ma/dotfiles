-- highlight yanked text for 200ms using the "Visual" highlight group
-- ref: <https://stackoverflow.com/questions/26069278/highlight-copied-area-in-vim>
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- open/close lsp hover floating window
-- https://vi.stackexchange.com/questions/37225/how-do-i-close-a-hovered-window-with-lsp-information-escape-does-not-work
local hover_close = function(base_win_id)
	local windows = vim.api.nvim_tabpage_list_wins(0)
	for _, win_id in ipairs(windows) do
		if win_id ~= base_win_id then
			local win_cfg = vim.api.nvim_win_get_config(win_id)
			if win_cfg.relative == "win" and win_cfg.win == base_win_id then
				vim.api.nvim_win_close(win_id, {})
				break
			end
		end
	end
end

-- Later, or in another file, when you create keymaps for LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local keymap_opts = { remap = false, silent = true, buffer = ev.buf }
		vim.keymap.set("n", "<leader>kh", vim.lsp.buf.hover, keymap_opts)
		vim.keymap.set("n", "<Leader>kq", function()
			hover_close(vim.api.nvim_get_current_win())
		end, keymap_opts)
	end,
})

-- Alternative to gutentags is to rebuild DB using :Cscope db build or <prefix>b.

-- local group = vim.api.nvim_create_augroup("CscopeBuild", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = { "*.c", "*.h" },
-- 	callback = function()
-- 		vim.cmd("Cscope db build")
-- 	end,
-- 	group = group,
-- })

-- https://github.com/smzm/MyDotFiles/blob/master/.config/nvim/

-- Check for spelling in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- inlayHint
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- inlay hint
		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable()
		end
	end,
})


