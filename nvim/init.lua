require("core.basic")
require("core.keybindings")
require("lsp.setup")
require("lsp.cmp")
require("lsp.ui")
require("plugins/plugin-setup")
require("plugins.clipboard")
require("plugins.comment")
require("plugins.debug")
require("plugins.filetype")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.navigation")
require("plugins.nvim-autopairs")
require("plugins.nvim-spider")
require("plugins.nvim-treesitter")
require("plugins.onedark")
require("plugins.rust-lang")
require("plugins.symbols-outline")
require("plugins.telescope")
require("plugins.toggleterm")

-- wsl clipboard configuration
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
