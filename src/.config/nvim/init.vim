" visual
set number
set noerrorbells
set showmatch matchtime=1
set cinoptions+=:0
set cmdheight=2
set laststatus=2
set showcmd
set display=lastline
set list
set showmatch
set cursorline
set autoread


" search
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

" edit
inoremap jj <Esc>
noremap <Esc><Esc> :noh<CR>
noremap ; :
set clipboard+=unnamedplus
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smartindent

" chigiri of korosazu
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" エスケープシーケンスの待機時間
set ttimeoutlen=10

"autocmd InsertEnter   * !ogg123 -q -d pulse ~/tmp/random/chestopen.ogg &
"autocmd InsertLeave   * !ogg123 -q -d pulse ~/tmp/random/chestclosed.ogg &
"autocmd InsertCharPre * !ogg123 -q -d pulse ~/tmp/step/stone1.ogg &
"autocmd BufWrite      * !ogg123 -q -d pulse ~/tmp/random/levelup.ogg &
"autocmd VimLeave      * !ogg123 -q -d pulse ~/tmp/random/explode1.ogg &


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/tatikaze/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/tatikaze/.cache/dein')
  call dein#begin('/home/tatikaze/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/tatikaze/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('mattn/vim-lsp-settings')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

let g:dein#auto_recache = 1

"End dein Scripts-------------------------


" 以下プラグインロード後に行う設定

let g:lsp_settings_servers_dir = '/home/tatikaze/.local/share/vim-lsp-settings-set/servers'
" 補完関連
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_smart_case=1
let g:neocomplete#min_keyword_length=1
let g:neocomplete#auto_completion_start_length=1
let g:deoplete#enable_at_startup=1
let g:deoplete#auto_completion_start_length=0

set termguicolors

let g:ale_sign_column_always = 1

