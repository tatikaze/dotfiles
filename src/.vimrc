call plug#begin()

Plug 'prettier/vim-prettier', { 
\	'do': 'yarn install',
\	'branch': 'release/1.0.0-alpha'
\}

" colorscheme
Plug 'cocopon/iceberg.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sickill/vim-monokai'

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

" fish
Plug 'dag/vim-fish'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" nerdtree
Plug 'preservim/nerdtree'

call plug#end()

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

" colorscheme
let g:solarized_termcolors=256
set background=dark
syntax on
colorscheme iceberg

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

" NerdTree
map <C-n> :NERDTreeToggle<CR>

" Coc format
noremap <C-f> :call CocAction('format')<CR>
