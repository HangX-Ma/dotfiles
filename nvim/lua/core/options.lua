-- general configuration
-- ref: <https://www.ruanyifeng.com/blog/2018/09/vimrc.html>

-- set vim leader to <space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- open doxygen syntax highlight
vim.g.load_doxygen_syntax = 1

local opt = vim.opt

-- speed up lua load time
vim.loader.enable()

-- line number
opt.relativenumber = true -- show relative line number
opt.number = true -- show line number

-- highlight
opt.cursorline = true -- highlight the line where the cursor points

-- tab
-- ref: <https://www.jianshu.com/p/162c19cc9c11>
opt.tabstop = 4 -- determine one tab length is 4 space
opt.shiftwidth = 4 -- indent length for each level, usually equals to 'tabstop'
opt.expandtab = true -- use space to replace the tab
opt.autoindent = true -- the new tab level will use the same format as previous ones
opt.smartindent = true

-- render
opt.termguicolors = true -- the nvim terminal will become colorful
opt.signcolumn = "yes"
opt.conceallevel = 2

-- coding
opt.wrap = false -- don't wrap the codes when too long

-- search
opt.ignorecase = true -- ignore the case while searching
opt.smartcase = true -- if 'ignorecase' is also true, case sensitive when exists only one uppercase character, otherwise not

-- spell check
opt.spelllang = "en_us,cjk"
opt.spell = false

-- split windows
opt.splitright = true -- prefer to split the new windows right
opt.splitbelow = true -- prefer to split the new windows below
opt.title = true

-- appearance
opt.signcolumn = "yes"

-- other
opt.formatoptions = opt.formatoptions
	- "t" -- wrap with text width
	+ "c" -- wrap comments
	- "r" -- insert comment after enter
	- "o" -- insert comment after o/O
	- "q" -- allow formatting of comments with gq
	- "a" -- format paragraphs
	+ "n" -- recognized numbered lists
	- "2" -- use indent of second line for paragraph
	+ "l" -- long lines are not broken
	+ "j" -- remove comment when joining lines

-- vim.o.winbar = " %{%v:lua.vim.fn.expand('%F')%}  %{%v:lua.require'nvim-navic'.get_location()%}"
