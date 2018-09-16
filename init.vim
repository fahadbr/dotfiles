set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

syntax on
set number
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set nowrap
set nohlsearch
set smartcase
set ignorecase
set incsearch
set showmatch
set cursorline
set mouse+=a
set hidden
set splitbelow
set splitright
set linebreak

set title
set ruler
set undolevels=1000
set backspace=indent,eol,start
set autoread
set grepprg=rg\ --vimgrep

au FocusGained,BufEnter * :checktime
"augroup numbertoggle
	"autocmd!
	"autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	"autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
"augroup END

let mapleader = ","

filetype plugin indent on

" Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug '$HOME/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/BufOnly.vim'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-surround'
Plug 'tomlion/vim-solidity'

" Colors
Plug 'morhetz/gruvbox'
Plug 'andreasvc/vim-256noir'
Plug 'jonathanfilip/vim-lucius'
Plug 'NLKNguyen/papercolor-theme'
Plug 'arcticicestudio/nord-vim'
Plug 'drewtempelmeyer/palenight.vim'

" Start it up
let g:deoplete#enable_at_startup = 1

" Allow tab autocomplete
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<Tab>"


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
" let g:go_list_type = 'quickfix'
let g:go_list_type_commands = {"_guru": "quickfix"}


au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>d <Plug>(go-def)
au FileType go nmap <F1> <Plug>(go-doc)
au FileType go nmap <F6> <Plug>(go-rename)
au FileType go nmap <F7> <Plug>(go-referrers)
au FileType go nmap <F12> :GoDecls<CR>
au FileType go nmap <leader>e <Plug>(go-iferr)


" ale config
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

" Enable integration with airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

let g:airline_theme = 'jellybeans'

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
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

call plug#end()

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <M-l> <Plug>AirlineSelectNextTab
nmap <M-h> <Plug>AirlineSelectPrevTab

" switch to previous buffer then close tab
nnoremap <M-w> :bp\| bd #<CR>
nnoremap <M-p> :Buffers<CR>

nnoremap <M-n> :NERDTreeToggle<CR>
nnoremap <M-S-n> :NERDTreeFind<CR>
nnoremap <M-S-p> :Files<CR>
nnoremap <M-z> :set wrap!<CR>
nnoremap <M-/> :set hlsearch!<CR>
" changing instances of current word
nnoremap <leader>cw *Ncgn
" searching for visual selection
vnoremap <leader>/ "vy/\V<C-r>v<CR>
vnoremap * "vy/\<<C-r>v\><CR>
vnoremap # "vy?\<<C-r>v\><CR>
vnoremap g* "vy/<C-r>v<CR>
vnoremap g# "vy?<C-r>v<CR>
" changing instances of visual selection
vnoremap <leader>cw "vy/<C-r>v<CR>Ncgn


" terminal shortcuts
nnoremap <M-t> :15split \| terminal<CR>
tnoremap <M-Tab> <C-\><C-n>

" remapping escape in various modes
nnoremap <M-Tab> <Esc>
onoremap <M-Tab> <Esc>
cnoremap <M-Tab> <C-c><Esc>
inoremap <M-Tab> <Esc>`^
vnoremap <M-Tab> <Esc>gV

" mapping window movements
nnoremap <M-S-k> <C-w>k
nnoremap <M-S-j> <C-w>j
nnoremap <M-S-h> <C-w>h
nnoremap <M-S-l> <C-w>l
nnoremap <M-S-q> <C-w>q
nnoremap <M-S-s> <C-w>s
nnoremap <M-S-v> <C-w>v
nnoremap <M-+> <C-w>+
nnoremap <M-_> <C-w>-
nnoremap <M-<> <C-w><
nnoremap <M->> <C-w>>

" quickfix/location list navigation
nnoremap <F2> :lnext<CR>
nnoremap <M-F2> :lprevious<CR>
nnoremap <F3> :cnext<CR>
nnoremap <M-F3> :cprevious<CR>

" cmdline mapping
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" custom fzf functions
" ripgrep search
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" ripgrep with fixed expression search
command! -bang -nargs=* Rgf
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always -F '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Gruvbox
" This HAS to be after plugged :)
let g:gruvbox_contrast_dark='hard'

set t_Co=256
let base16colorspace=256
set background=dark
colorscheme gruvbox

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" vim-session options
"let g:session_autosave = 'yes'
"let g:session_autosave_periodic = 5
let g:session_persist_colors = 0

" disable auto pair shortcuts
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutBackInsert = ''
