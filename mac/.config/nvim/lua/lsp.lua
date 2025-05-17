-- LSPの基本設定
local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

lspconfig.ts_ls.setup {
  capabilities = capabilities,
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        -- Neovimのグローバル変数を認識させる
        globals = { 'vim' },
      },
    },
  },
}

-- ddc.vimの設定
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  _ = {
    matchers = { 'matcher_fuzzy' },
    sorters = { 'sorter_rank' },
  },
  ['nvim-lsp'] = {
    mark = 'lsp',
    forceCompletionPattern = '\\.|:|->|\\w\\/',
  },
  ['copilot'] = {
    mark = 'copilot',
  },
})

-- ddc.vimを有効化
vim.fn['ddc#enable']()
