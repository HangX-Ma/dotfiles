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
