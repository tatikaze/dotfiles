-- 基本設定
vim.o.number = true
vim.o.clipboard = "unnamed"
vim.o.encoding = "UTF-8"
vim.o.wrap = true

vim.cmd([[packadd packer.nvim]])
-- Packerの設定
require("packer").startup(function()
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- プラグインのリスト
  use("vim-denops/denops.vim")
  use("Shougo/ddc-nvim-lsp")
  use("Shougo/ddc.vim")
  use("neovim/nvim-lspconfig")
  -- For LSP capabilities required by ddc-nvim-lsp
  use("hrsh7th/nvim-cmp") -- The main cmp plugin
  use("hrsh7th/cmp-buffer") -- buffer completions
  use("hrsh7th/cmp-path") -- path completions
  use("hrsh7th/cmp-cmdline") -- cmdline completions
  use("hrsh7th/cmp-nvim-lsp") -- LSP completions
  use("hrsh7th/cmp-nvim-lua") -- nvim lua completions
  use("hrsh7th/vim-vsnip")
  use({ "onsails/lspkind.nvim" })
  use("uga-rosa/ddc-source-vsnip")

  use("editorconfig/editorconfig-vim")

  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
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

  -- coc.nvimの設定はLuaでの直接的な変換が難しいため、代わりにNeovimのネイティブLSPを検討してください
  -- use {'neoclide/coc.nvim', branch = 'release'}
  use("thinca/vim-qfreplace")
  use("rhysd/github-complete.vim")
  use("rakr/vim-one")
  use("cocopon/iceberg.vim")
  use("sickill/vim-monokai")
  use("vim-airline/vim-airline")
  use("vim-airline/vim-airline-themes")
  use("ryanoasis/vim-devicons")
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("nathanaelkane/vim-indent-guides")
  use("pangloss/vim-javascript")
  use("leafgarland/typescript-vim")
  use("peitalin/vim-jsx-typescript")
  use("HerringtonDarkholme/yats.vim")
  use("nvim-lua/plenary.nvim")
  use("vim-test/vim-test")
  use("nvimtools/none-ls.nvim")
  use("MunifTanjim/prettier.nvim")
  use("mhartington/formatter.nvim")
  use("wesleimp/stylua.nvim")
  use("prisma/vim-prisma")
end)

require("lsp")

-- カラースキーム
vim.cmd([[colorscheme iceberg]])

vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- エアラインの設定
vim.g.airline_theme = "violet"
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g.airline_powerline_fonts = 1

-- 背景透過
vim.cmd([[
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
]])

-- lspkind.lua
local lspkind = require("lspkind")
lspkind.init({
  symbol_map = {
    Text = "␂",
    Method = "m",
    Function = "⎔",
    Constructor = "",
    Field = "󰜢",
    Variable = "$",
    Class = "c",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "$",
    Enum = "",
    Keyword = "ω",
    Snippet = "",
    Color = "🌈",
    File = "␜",
    Reference = "※",
    Folder = "Fo",
    EnumMember = "",
    Constant = "ℎ",
    Struct = "⌂",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
    Copilot = "",
  },
})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

local cmp = require("cmp")

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = "...",
      show_labelDetails = true,
    }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(t("<Down>"), "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
    ["<C-p>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(t("<Up>"), "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
    }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "copilot", group_index = 2 },
    { name = "path" },
    { name = "nvim_lsp", group_index = 2 },
    { name = "vsnip", group_index = 2 },
  }),
})

require("format")
require("null_ls")
vim.api.nvim_set_keymap("n", "<C-f>", "<cmd>Format<CR>", { noremap = true, silent = true })
