local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anymous"](args.body)
        end,
    },

    window = {
    },

    mapping = {
        -- select previous one
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- select next one
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- show auto complete
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        -- cancel auto complete
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),

        -- select
        ['<CR>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
        }),

        -- scroll up
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        -- scroll down
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    },

    -- 补全来源
    sources = cmp.config.sources({
        {name = 'nvim_lsp'},
        {name = 'vsnip'},
        {name = 'buffer'},
        {name = 'path'}
    }),

    --根据文件类型来选择补全来源
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            {name = 'buffer'}
        })
    }),

    -- 命令模式下输入 `/` 启用补全
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    }),

    -- 命令模式下输入 `:` 启用补全
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
                { name = 'cmdline' }
            })
    }),
    formatting = require('lsp.ui').formatting
})
