local status, formatter = pcall(require, 'formatter')
if not status then
    vim.notify('cannot find formatter')
    return
end

local util = require "formatter.util"
formatter.setup({
    filetype = {
        cpp = {
            -- clang-format
            function()
                return {
                    exe = 'clang-format',
                    args = {},
                    stdin = true,
                    try_node_modules = true,
                }
            end,
        },
        lua = {
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        c = {
            -- clang-format
            function()
                return {
                    exe = 'clang-format',
                    args = {},
                    stdin = true,
                    try_node_modules = true,
                }
            end,
        },
        python = {
            -- black
            function()
                return {
                    exe = 'black',
                    args = {},
                    stdin = true,
                }
            end,
        },
        rust = {
            -- Rustfmt
            function()
                return {
                    exe = 'rustfmt',
                    args = { '--emit=stdout' },
                    stdin = true,
                }
            end,
        },
    },
})
