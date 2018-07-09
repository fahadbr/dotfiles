set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

syntax on
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set nowrap
set hlsearch
set smartcase
set ignorecase
set incsearch
set showmatch
set cursorline
set mouse+=a
set hidden

set ruler
set undolevels=1000
set backspace=indent,eol,start

filetype plugin indent on

" Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'


" Colors
Plug 'morhetz/gruvbox'
Plug 'andreasvc/vim-256noir'
Plug 'jonathanfilip/vim-lucius'

" Start it up
let g:deoplete#enable_at_startup = 1

" Allow tab autocomplete
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"
nnoremap <M-Tab> :bn<CR>
nnoremap <M-S-Tab> :bp<CR>

" Disable the preview window on tab complete
set completeopt-=preview

" rust deoplete rust
"Plug 'sebastianmarkow/deoplete-rust'
"Plug 'rust-lang/rust.vim'
"
"let g:deoplete#sources#rust#racer_binary='$HOME/.cargo/bin/racer'
"let g:deoplete#sources#rust#rust_source_path='/usr/lib/rustlib/src/rust/src'
"let g:deoplete#sources#rust#disable_keymap=1
"
"let g:rust_recommended_style = 0


" clang plugins
Plug 'zchee/deoplete-clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'


" golang vim-go options
Plug 'zchee/deoplete-go', {'do': 'make'}
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'fatih/vim-go'

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_fmt_command="goimports"


" ale config
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

" Enable integration with airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" airline tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buf_label_first = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

nmap <leader>1 :1b<CR> 
nmap <leader>2 :2b<CR>
nmap <leader>3 :3b<CR>
nmap <leader>4 :4b<CR>
nmap <leader>5 :5b<CR>
nmap <leader>6 :6b<CR>
nmap <leader>7 :7b<CR>
nmap <leader>8 :8b<CR>
nmap <leader>9 :9b<CR>
nmap <leader>0 :0b<CR>

call plug#end()

" Gruvbox
" This HAS to be after plugged :)
" let g:gruvbox_contrast_dark='hard'

" Lucius
let g:lucius_style = 'dark'
let g:lucius_contrast = 'high'
" let g:lucius_contrast_bg = 'high'


set t_Co=256
let base16colorspace=256
set background=dark
colorscheme lucius


