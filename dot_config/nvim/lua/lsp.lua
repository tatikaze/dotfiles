-- LSPの基本設定（vim.lsp.configベース）
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

local function setup(server, opts)
  local defaults = {
    capabilities = capabilities,
    on_attach = on_attach,
  }
  vim.lsp.config(server, vim.tbl_deep_extend("force", defaults, opts or {}))
  vim.lsp.enable(server)
end

setup("ts_ls", {
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  settings = {
    typescript = {
      exclude = { "*/**/dist", "@/dist" },
    },
  },
})

setup("jsonnet_ls")

setup("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        -- Neovimのグローバル変数を認識させる
        globals = { "vim" },
      },
    },
  },
})

setup("biome")
