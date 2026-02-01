return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    init = function()
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
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    init = function()
      require("CopilotChat").setup({
        model = "claude-sonnet-4",
        keymaps = {
          toggle = "<C-\\>",
          next = "<C-n>",
          prev = "<C-p>",
          accept = "<C-y>",
          close = "<C-c>",
        },
        window = {
          width = 80,
          height = 20,
        },
      })
    end,
  },
}
