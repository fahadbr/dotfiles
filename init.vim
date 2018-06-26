set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

syntax on

set number
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

set ruler
set undolevels=1000
set backspace=indent,eol,start

filetype plugin indent on

" Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'zchee/deoplete-go', {'do': 'make'}
Plug 'sebastianmarkow/deoplete-rust'
Plug 'vim-airline/vim-airline'

" Colors
Plug 'morhetz/gruvbox'
Plug 'andreasvc/vim-256noir'
Plug 'jonathanfilip/vim-lucius'

" Start it up
let g:deoplete#enable_at_startup = 1

" Allow tab autocomplete
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"

" Disable the preview window on tab complete
set completeopt-=preview

" rust deoplete rust
let g:deoplete#sources#rust#racer_binary='$HOME/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/usr/lib/rustlib/src/rust/src'
let g:deoplete#sources#rust#disable_keymap=1

" Yuck
let g:rust_recommended_style = 0

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


