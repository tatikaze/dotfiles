-- lspkind.lua
local lspkind = require 'lspkind'
lspkind.init {
  symbol_map = {
    Text = '␂',
    Method = 'm',
    Function = '⎔',
    Constructor = '',
    Field = '󰜢',
    Variable = '$',
    Class = 'c',
    Interface = '',
    Module = '',
    Property = '󰜢',
    Unit = '󰑭',
    Value = '$',
    Enum = '',
    Keyword = 'ω',
    Snippet = '',
    Color = '🌈',
    File = '␜',
    Reference = '※',
    Folder = 'Fo',
    EnumMember = '',
    Constant = 'ℎ',
    Struct = '⌂',
    Event = '',
    Operator = '󰆕',
    TypeParameter = '',
    Copilot = '',
  },
}
vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

local cmp = require 'cmp'

cmp.setup {
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      show_labelDetails = true,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping {
      c = function(t)
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          vim.api.nvim_feedkeys(t '<Down>', 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end,
    },
    ['<C-p>'] = cmp.mapping {
      c = function(t)
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          vim.api.nvim_feedkeys(t '<Up>', 'n', true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        else
          fallback()
        end
      end,
    },
    ['<Tab>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = cmp.config.sources {
    { name = 'copilot', group_index = 2 },
    { name = 'path' },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'vsnip', group_index = 2 },
  },
}
