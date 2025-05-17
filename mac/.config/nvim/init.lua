-- 基本設定
vim.o.number = true
vim.o.clipboard = 'unnamed'
vim.o.encoding = 'UTF-8'
vim.o.wrap = true

-- 入力を待ってエラー
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

require 'packages'
require 'lsp'
require 'styles'
require 'completions'
require 'format'
require 'null_ls'

vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>Format<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':split | lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
