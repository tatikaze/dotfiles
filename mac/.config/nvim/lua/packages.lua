vim.cmd([[packadd packer.nvim]])
-- Packerの設定
require("packer").startup(function(use)
  -- Packer

  -- 自動補完
  use("Shougo/ddc-nvim-lsp")
  use("Shougo/ddc.vim")
  use("neovim/nvim-lspconfig")
  -- LSP
  use("hrsh7th/nvim-cmp") -- The main cmp plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("hrsh7th/cmp-nvim-lsp") -- LSP completions
  use("hrsh7th/cmp-nvim-lua") -- nvim lua completions
  use("hrsh7th/vim-vsnip")
  use({ "onsails/lspkind.nvim" })
  use("uga-rosa/ddc-source-vsnip")

  -- ツール系
  use("editorconfig/editorconfig-vim")
  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true },
        panel = { enabled = true },
        filetypes = {
          lua = true,
          javascript = true,
          typescript = true,
        },
      })
    end,
  })
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  })
  use("CopilotC-Nvim/CopilotChat.nvim")

  use("thinca/vim-qfreplace")
  use("rhysd/github-complete.vim")
  use("junegunn/fzf")
  use("junegunn/fzf.vim")

  -- 見た目系
  use("sickill/vim-monokai")
  
  use("pangloss/vim-javascript")
  use("leafgarland/typescript-vim")
  use("peitalin/vim-jsx-typescript")
  use("HerringtonDarkholme/yats.vim")
  use("vim-test/vim-test")
  use("MunifTanjim/eslint.nvim")
  use("prisma/vim-prisma")
end)
