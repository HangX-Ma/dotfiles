local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- auto PakcerSync plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugin-setup.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
    -- Packer
    use 'wbthomason/packer.nvim'

    -- atom one dark colortheme
    use 'navarasu/onedark.nvim'

    -- status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }

    -- navigation start
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
    use('christoomey/vim-tmux-navigator')
    use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'nvim-tree/nvim-web-devicons' }
    use { 'simrat39/symbols-outline.nvim' }
    -- navigation end

    -- toggleterm Terminal
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }

    use { 'rcarriga/nvim-notify', config = function ()
        require("notify").setup({
            background_colour = "#000000"
        })
    end }

    -- highlight start
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'nvim-treesitter/nvim-treesitter-context' }
    use { 'p00f/nvim-ts-rainbow', requires = 'nvim-treesitter/nvim-treesitter' }
    use { "iamcco/markdown-preview.nvim", run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, }
    -- highlight end

    -- comment
    use 'numToStr/Comment.nvim'

    -- search start
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- search end

    -- LSP Mason
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }
    use "onsails/lspkind-nvim"
    use "glepnir/lspsaga.nvim"

    -- auto-complete start
    -- nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    -- vsnip
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    -- luasnip
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"
    -- autopair
    use 'windwp/nvim-autopairs'
    -- auto-complete end

    -- clipboard
    use 'EtiamNullam/deferred-clipboard.nvim'

    -- rust
    -- use 'simrat39/rust-tools.nvim'

    -- git
    use({
        'kdheepak/lazygit.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    })
    use('lewis6991/gitsigns.nvim')

    -- speed up
    use('nathom/filetype.nvim')

    -- startuptime
    use('dstein64/vim-startuptime')

    -- camelcase motion
    use('chrisgrieser/nvim-spider')

    -- greeter
    use {
        'startup-nvim/startup.nvim',
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require "startup".setup({ theme = "dashboard" })
        end
    }

    -- which key
    use { 'folke/which-key.nvim', config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end
    }

    -- debug
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { "theHamsta/nvim-dap-virtual-text" }

    -- trouble
    use { "folke/trouble.nvim", requires = { 'nvim-tree/nvim-web-devicons' } }
    -- todo
    use { "folke/todo-comments.nvim", requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("todo-comments").setup {}
        end
    }

    -- leetcode
    use { "kawre/leetcode.nvim",
        run = ":TSUpdate html",
        requires = {
            {"nvim-telescope/telescope.nvim"},
            {"nvim-lua/plenary.nvim"}, -- required by telescope
            {"MunifTanjim/nui.nvim"},

            -- optional
            {"nvim-treesitter/nvim-treesitter"},
            {"rcarriga/nvim-notify"},
            {"nvim-tree/nvim-web-devicons"},
            {"3rd/image.nvim"}
        },
    }


    -- riscv
    use 'kylelaker/riscv.vim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
