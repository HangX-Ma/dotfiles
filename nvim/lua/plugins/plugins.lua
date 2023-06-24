local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'
  -- atom one dark theme
  use 'navarasu/onedark.nvim'
  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- navigation start
  use 'nvim-tree/nvim-tree.lua'
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional
  }
  use('christoomey/vim-tmux-navigator')
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'nvim-tree/nvim-web-devicons'}
  use {'simrat39/symbols-outline.nvim', lazy = true }
  -- navigation end

  -- toggleterm Terminal
  use {"akinsho/toggleterm.nvim", tag = 'v2.*', config = function()
    require("toggleterm").setup()
  end}

  -- highlight end
  use 'nvim-treesitter/nvim-treesitter'
  use 'p00f/nvim-ts-rainbow'
  -- highlight end

  -- comment
  use 'numToStr/Comment.nvim'

  -- search start
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- search end

  -- LSP Mason
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }
  use {
    "j-hui/fidget.nvim", tag = 'legacy',
     config = function()
       require("fidget").setup()
     end
  }

  -- auto-complete start
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'windwp/nvim-autopairs'
  -- auto-complete end

  -- snippets
  use "rafamadriz/friendly-snippets"

  -- debug start
  use 'puremourning/vimspector'
  use 'mfussenegger/nvim-dap'
  -- debug end

  -- rust
  use 'simrat39/rust-tools.nvim'

  -- clipboard
  use {
    'EtiamNullam/deferred-clipboard.nvim', tag = 'v0.8.0'
  }

  -- git
  use({
      "kdheepak/lazygit.nvim",
      requires = {
          "nvim-telescope/telescope.nvim",
          "nvim-lua/plenary.nvim",
      },
      config = function()
          require("telescope").load_extension("lazygit")
      end,
  })
  use('lewis6991/gitsigns.nvim')

  -- speed up
  use("nathom/filetype.nvim")

  -- greeter
  use {
    "startup-nvim/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      require"startup".setup()
    end
  }

  -- riscv
  use 'kylelaker/riscv.vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)