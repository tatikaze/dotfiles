set number
set clipboard=unnamed
set encoding=UTF-8

call plug#begin('~/.vim/plugged')

" global settings
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'editorconfig/editorconfig-vim'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
xmap <c-f>  <Plug>(coc-format)
nmap <c-f>  <Plug>(coc-format)
nnoremap <nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-n>"
nnoremap <nowait><expr> <C-p> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-p>"

" colorschemes
Plug 'rakr/vim-one'
Plug 'cocopon/iceberg.vim'
Plug 'sickill/vim-monokai'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
let g:airline_theme = 'papercolor'               " テーマの指定
let g:airline#extensions#tabline#enabled = 1 " タブラインを表示
let g:airline_powerline_fonts = 1            " Powerline Fontsを利用

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" common
Plug 'editorconfig/editorconfig-vim'
Plug 'nathanaelkane/vim-indent-guides'

" JS & TS 
" REQUIRED: Add a syntax file. YATS is the best
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }

Plug 'pantharshit00/vim-prisma'

Plug 'wesleimp/stylua.nvim'

call plug#end()

colorscheme iceberg

" Alias
cnoreabbrev idt IndentGuidesToggle

" 背景透過
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
