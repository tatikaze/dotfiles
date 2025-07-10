local util = require("formatter.util")

local function find_in_parents(filename)
  local dir = vim.fn.expand("%:p:h")
  local prev_dir = ""
  while dir ~= prev_dir do
    -- .gitディレクトリが存在するかチェック
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      -- .gitディレクトリが存在する場合、biome.jsonを探す
      if vim.fn.filereadable(dir .. "/" .. filename) == 1 then
        return dir .. "/" .. filename
      else
        -- .gitディレクトリまで到達したので、これ以上遡らない
        return nil
      end
    end
    -- biome.jsonが存在するかチェック
    if vim.fn.filereadable(dir .. "/" .. filename) == 1 then
      return dir .. "/" .. filename
    end
    prev_dir = dir
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

local function biomeOrPrettierFormat()
  -- biome.jsonが存在するかチェック
  local biome_json_path = find_in_parents("biome.json")
  if biome_json_path ~= nil then
    -- biome.jsonが存在する場合、biomeフォーマッタを使用
    print("formatting by biome...")
    return {
      exe = "biome",
      args = {
        "format",
        "--stdin-file-path",
        util.escape_path(util.get_current_buffer_file_path()),
      },
      stdin = true,
    }
  else
    print("formatting by prettier...")
    local filepath = vim.api.nvim_buf_get_name(0)
    local command = vim.fn.shellescape(filepath)

    return {
      exe = "prettier",
      args = { "--stdin-filepath", command },
      stdin = true,
    }
  end
end

local prismaFormat = function()
  return {
    exe = "prisma",
    args = { "format" },
    stdin = false,
  }
end

local terraformFormat = function()
  return {
    exe = "terraform",
    args = { "fmt", "-" },
    stdin = true,
  }
end

local jsonnetFormat = function()
  vim.cmd("JsonnetFmt")
end

local markdownFormat = function()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
    stdin = true,
  }
end

require("formatter").setup({
  filetype = {
    lua = {
      require("formatter.filetypes.lua").stylua,
      function()
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },
    typescript = {
      biomeOrPrettierFormat,
    },
    typescriptreact = {
      biomeOrPrettierFormat,
    },
    javascript = {
      biomeOrPrettierFormat,
    },
    javascriptreact = {
      biomeOrPrettierFormat,
    },
    json = {
      biomeOrPrettierFormat,
    },
    prisma = {
      prismaFormat,
    },
    terraform = {
      terraformFormat,
    },
    jsonnet = {
      jsonnetFormat,
    },
    md = {
      markdownFormat,
    },
    mdx = {
      markdownFormat,
    },
  },
})
