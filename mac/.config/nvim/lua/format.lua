local util = require("formatter.util")

local prettierFormat = function()
  print("formatting")
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
    stdin = true,
  }
end

local prismaFormat = function()
  return {
    exe = "prisma",
    args = { "format" },
    stdin = false,
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
      prettierFormat,
    },
    typescriptreact = {
      prettierFormat,
    },
    javascript = {
      prettierFormat,
    },
    javascriptreact = {
      prettierFormat,
    },
    json = {
      prettierFormat,
    },
    prisma = {
      prismaFormat,
    },
  },
})
require("js_formatter")
