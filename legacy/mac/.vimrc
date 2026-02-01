call plug#begin()

Plug 'prettier/vim-prettier', { 
\	'do': 'yarn install',
\	'branch': 'release/1.0.0-alpha'
\}

" colorscheme
Plug 'cocopon/iceberg.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'

" language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'phpactor/phpactor'

"javascript & typescript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'] }
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx'] }

"  syntax hight light
Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'typescript.tsx'] }

" Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
" Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/html5.vim'

" Dart
Plug 'dart-lang/dart-vim-plugin', { 'for': ['dart'] }

" Flutter
Plug 'thosakwe/vim-flutter'

" Prismajs
Plug 'pantharshit00/vim-prisma'

" PlantUML
Plug 'aklt/plantuml-syntax'

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

set backspace=2

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

" clipboard
" set clipboard=unnamedplus

set tabstop=2
set shiftwidth=2

nnoremap j gj
nnoremap k gk

" colorscheme
set termguicolors  
" let g:solarized_termcolors=256
" syntax on
let ayucolor="dark"   " for dark version of theme
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

" PlantUML
au FileType plantuml command! OpenUml :!open "/Applications/Google Chrome.app" --args --disable-web-security --user-data-dir="dummy" file:///Users/liu/dev/plantuml/%

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
