-- default values
require("spider").setup {
	skipInsignificantPunctuation = true,
	subwordMovement = true,
	customPatterns = {}, -- check Custom Movement Patterns for details
}

vim.keymap.set(
	{ "n", "o", "x" },
	"<leader>w",
	"<cmd>lua require('spider').motion('w')<CR>",
	{ desc = "Spider-w" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<leader>e",
	"<cmd>lua require('spider').motion('e')<CR>",
	{ desc = "Spider-e" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"<leader>b",
	"<cmd>lua require('spider').motion('b')<CR>",
	{ desc = "Spider-b" }
)
vim.keymap.set(
    { "n", "o", "x" },
    "<leader>ge",
    "<cmd>lua require('spider').motion('ge')<CR>",
    { desc = "Spider-ge" }
)

