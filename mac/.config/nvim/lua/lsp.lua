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

-- ddc.vimの設定
vim.fn["ddc#custom#patch_global"]("sourceOptions", {
  _ = {
    matchers = { "matcher_fuzzy" },
    sorters = { "sorter_rank" },
  },
  ["nvim-lsp"] = {
    mark = "lsp",
    forceCompletionPattern = "\\.|:|->|\\w\\/",
  },
  ["copilot"] = {
    mark = "copilot",
  },
})

-- biome
lspconfig.biome.setup({})

-- terraform
--lspconfig.terraformls.setup({
--  handlers = {
--    ['textDocument/semanticTokens'] = function() end,
--    ['textDocument/semanticTokens/full'] = function() end,
--  },
--})
--
---- Terraformのファイルを保存時にフォーマット
--vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--  pattern = { "*.tf", "*.tfvars" },
--  callback = function()
--    vim.lsp.buf.format()
--  end,
--})

-- ddc.vimを有効化
vim.fn["ddc#enable"]()

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

require("notify").setup({
  background_colour = "#000000",
})
