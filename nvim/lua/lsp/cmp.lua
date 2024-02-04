local cmp = require("cmp")
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anymous"](args.body) -- For `vsnip` users, it fails
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = {
        -- select previous one
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- select next one
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- show auto complete
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
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
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        -- scroll down
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' }
    }),

    -- according filetype to select sources
    cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'buffer' }
        })
    }),

    -- use '/' to trigger auto complete under command mode
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    }),

    -- use ':' to trigger auto complete under command mode
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        },{
            { name = 'cmdline' }
        })
    }),
    formatting = require('lsp.ui').formatting
})
