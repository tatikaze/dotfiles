-- LSPの基本設定
local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

lspconfig.ts_ls.setup {
  capabilities = capabilities,
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
}

local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- 定義ジャンプなど
  bufmap("n", "<leader>d", vim.lsp.buf.definition, "Go to definition")
  bufmap("n", "gr", vim.lsp.buf.references, "Find references")
  bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  bufmap("n", "<leader>D", vim.lsp.buf.type_definition, "Go to type definition")
end

local servers = { "jsonnet_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    typescript = {
      exclude = { "*/**/dist", "@/dist" },
    },
  },
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        -- Neovimのグローバル変数を認識させる
        globals = { 'vim' },
      },
    },
  },
})

-- biome
lspconfig.biome.setup({})
