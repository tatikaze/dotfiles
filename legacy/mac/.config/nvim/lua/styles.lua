-- カラースキーム
vim.cmd([[colorscheme iceberg]])

-- 背景透過
vim.cmd([[
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
]])

-- エアラインの設定
require("lualine").setup({
	options = {
		theme = "ayu_dark",
	},
})
