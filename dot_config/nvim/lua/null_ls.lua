local null_ls = require 'null-ls'

null_ls.setup {
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.formatting.prettier.with({
      condition = function(util)
        return not util.root_has_file("biome.json")
      end,
    }),
    require("none-ls.diagnostics.eslint").with({
      condition = function(util)
        return util.root_has_file(".eslintrc.js")
      end,
    }),
    require("null-ls").builtins.formatting.biome.with({
      condition = function(util)
        return util.root_has_file("biome.json")
      end,
    }),
  },
}
