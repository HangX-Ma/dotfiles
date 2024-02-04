require("core.options")
require("core.keymaps")
require("plugins.plugins")
require("plugins.clipboard")
require("plugins.cmp")
require("plugins.comment")
require("plugins.debug")
require("plugins.filetype")
require("plugins.gitsigns")
require("plugins.highlight")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.navigation")
require("plugins.nvim-spider")
require("plugins.onedark")
require("plugins.rust-lang")
require("plugins.symbols-outline")
require("plugins.telescope")
require("plugins.toggleterm")

if vim.fn.has("wsl") == 1 then
    if vim.fn.executable("wl-copy") == 0 then
        print("wl-clipboard not found, clipboard integration won't work")
    else
        vim.g.clipboard = {
            name = "wl-clipboard (wsl)",
            copy = {
                ["+"] = 'wl-copy --foreground --type text/plain',
                ["*"] = 'wl-copy --foreground --primary --type text/plain',
            },
            paste = {
                ["+"] = (function()
                    return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', {''}, 1) -- '1' keeps empty lines
                end),
                ["*"] = (function()
                    return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', {''}, 1)
                end),
            },
            cache_enabled = true
        }
    end
end
