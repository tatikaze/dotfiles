vim.cmd [[packadd packer.nvim]]
-- Packerの設定
require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'

  -- 自動補完
  use 'vim-denops/denops.vim'
  use 'Shougo/ddc-nvim-lsp'
  use 'Shougo/ddc.vim'
  use 'neovim/nvim-lspconfig'
  -- LSP
  use 'hrsh7th/nvim-cmp' -- The main cmp plugin
  use 'hrsh7th/cmp-buffer' -- buffer completions
  use 'hrsh7th/cmp-path' -- path completions
  use 'hrsh7th/cmp-cmdline' -- cmdline completions
  use 'hrsh7th/cmp-nvim-lsp' -- LSP completions
  use 'hrsh7th/cmp-nvim-lua' -- nvim lua completions
  use 'hrsh7th/vim-vsnip'
  use { 'onsails/lspkind.nvim' }
  use 'uga-rosa/ddc-source-vsnip'

  -- ツール系
  use 'editorconfig/editorconfig-vim'
  use {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          lua = true,
          javascript = true,
          typescript = true,
        },
      }
    end,
  }
  use {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  }
  use 'thinca/vim-qfreplace'
  use 'rhysd/github-complete.vim'
  use 'nvim-lua/plenary.nvim'
  use 'nvimtools/none-ls.nvim'
  use 'nvimtools/none-ls-extras.nvim'
  use 'mhartington/formatter.nvim'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- 見た目系
  use 'rakr/vim-one'
  use 'cocopon/iceberg.vim'
  use 'sickill/vim-monokai'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'ryanoasis/vim-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }

  use 'nathanaelkane/vim-indent-guides'
  use 'pangloss/vim-javascript'
  use 'leafgarland/typescript-vim'
  use 'peitalin/vim-jsx-typescript'
  use 'HerringtonDarkholme/yats.vim'
  use 'vim-test/vim-test'
  use 'MunifTanjim/prettier.nvim'
  use 'MunifTanjim/eslint.nvim'
  use 'prisma/vim-prisma'
  use 'wesleimp/stylua.nvim'
end)
