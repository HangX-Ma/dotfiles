-- general configuration
-- ref: <https://www.ruanyifeng.com/blog/2018/09/vimrc.html>
local opt = vim.opt

-- speed up lua load time
vim.loader.enable()

-- line number
opt.relativenumber = true       -- show relative line number
opt.number = true               -- show line number

-- highlight
opt.cursorline = true           -- highlight the line where the cursor points

-- tab
-- ref: <https://www.jianshu.com/p/162c19cc9c11>
opt.tabstop = 4                 -- determine one tab length is 4 space
opt.shiftwidth = 4              -- indent length for each level, usually equals to 'tabstop'
opt.expandtab = true            -- use space to replace the tab
opt.autoindent = true           -- the new tab level will use the same format as previous ones

-- render
opt.termguicolors = true        -- the nvim terminal will become colorful
opt.signcolumn = "yes"

-- coding
opt.wrap = false                -- don't wrap the codes when too long

-- search
opt.ignorecase = true           -- ignore the case while searching
opt.smartcase = true            -- if 'ignorecase' is also true, case sensitive when exists only one uppercase character, otherwise not

-- spell check
opt.spelllang="en,cjk"

-- split windows
opt.splitright = true           -- prefer to split the new windows right
opt.splitbelow = true           -- prefer to split the new windows below

-- Vimspector options
vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])