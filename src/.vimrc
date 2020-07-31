set fenc=utf-8

set nobackup

set noswapfile

set autoread

set hidden

set showcmd

" テキストハイライト
set hlsearch

" 行数表示
set number

" 自動インデント
set autoindent

" 補完の長さ
set pumheight=10

set cursorline

set virtualedit=onemore

set smartindent

set visualbell

set showmatch

set laststatus=2

set wildmode=list:longest

set tabstop=2
set shiftwidth=2

nnoremap j gj
nnoremap k gk

autocmd FileType vue syntax sync fromstart
syntax enable


call plug#begin('~/.vim/plugged')

Plug 'prettier/vim-prettier', { 
\	'do': 'yarn install',
\	'branch': 'release/1.0.0-alpha'
\}

" colorschema
Plug 'sainnhe/sonokai',  {'do': 'cp colors/* ~/.vim/colors'}
" language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"javascript & typescript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'javascript.tsx'] }
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/html5.vim'
Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascript.jsx'] }

" prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

" golang
Plug 'fatih/vim-go'

call plug#end()


" colorscheme settings
if has('termguicolors')
  set termguicolors
endif

let g:sonokai_style = 'andromeda'

colorscheme sonokai

" tab auto comlete select for coc
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
