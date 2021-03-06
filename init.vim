" vim:foldmethod=marker

" general option settings {{{
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

" neovim options
set inccommand=nosplit

au FocusGained,BufEnter * :checktime

let mapleader = ","
let maplocalleader = "-"

filetype plugin indent on
" }}}

" plug {{{

" pre-plug mappings {{{

nmap <Leader>r  <Plug>ReplaceWithRegisterOperator
nmap <Leader>rr <Plug>ReplaceWithRegisterLine
xmap <Leader>r  <Plug>ReplaceWithRegisterVisual

" }}}

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug '$HOME/.fzf'
Plug '$HOME/.dotfiles/fzfc'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-trailing-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/BufOnly.vim'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'rhysd/git-messenger.vim'
Plug 'morhetz/gruvbox'
Plug 'honza/vim-snippets'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'dbeniamine/todo.txt-vim'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'fatih/vim-go'
Plug 'tomlion/vim-solidity', { 'for': 'solidity' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'fenetikm/falcon'
Plug 'mhartington/oceanic-next'
Plug 'neovimhaskell/haskell-vim'
Plug 'jsit/toast.vim', { 'as': 'toast' }
Plug 'rhysd/vim-clang-format', { 'for': 'cpp' }
Plug 'vim-scripts/a.vim', { 'for' : ['c', 'cpp'] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'dart-lang/dart-vim-plugin'
Plug 'ianks/vim-tsx'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }

if (!has("nvim-0.5.0"))
  Plug 'SirVer/ultisnips'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
else
  Plug 'neovim/nvim-lsp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'golang/vscode-go', { 'for': 'go' }
  Plug 'nvim-lua/completion-nvim'
  Plug 'steelsojka/completion-buffers'
  Plug 'nvim-lua/diagnostic-nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/telescope.nvim'
endif

call plug#end()

" }}}

" neovim lsp config {{{
"
if (has("nvim-0.5.0"))

" lua config {{{
lua << EOF

function attach_callbacks ()
  require('completion').on_attach()
  require('diagnostic').on_attach()
end

-- for c++ support
require('nvim_lsp').ccls.setup{
  on_attach = attach_callbacks,
  init_options = {
    highlight = {
      lsRanges = true;
    }
  }
}

-- for go support
require('nvim_lsp').gopls.setup{
  on_attach = attach_callbacks,
  init_options = {
    completeUnimported = true,
    usePlaceholders = true,
    codelens = {
      gc_details = true,
      test = true
    }
  }
}

-- for rust support
require('nvim_lsp').rust_analyzer.setup{ on_attach = attach_callbacks }

-- for scala support
require('nvim_lsp').metals.setup{ on_attach = attach_callbacks }

-- for lua support
require('nvim_lsp').sumneko_lua.setup{ on_attach = attach_callbacks }

-- require('nlua.lsp.nvim').setup(require('nvim_lsp'), {
--   on_attach = attach_callbacks,
-- })

-- for viml support
require'nvim_lsp'.vimls.setup{}

--[[
vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
--]]

EOF
"}}}

" key mappings {{{
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <M-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
xnoremap <silent> <leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <space>o    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <space>s    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

" reload lsp
nnoremap <leader>cr <cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
"}}}

" telescope {{{
nnoremap <c-p> :lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader><space>o :lua require'telescope.builtin'.lsp_document_symbols{ shorten_path = true }<CR>
nnoremap <leader><space>s :lua require'telescope.builtin'.lsp_workspace_symbols{ shorten_path = true }<CR>
" }}}

" diagnostics {{{

 let g:diagnostic_enable_virtual_text = 1
 let g:diagnostic_enable_underline = 1
 let g:space_before_virtual_text = 5
 let g:diagnostic_insert_delay = 1
 let g:diagnostic_trimmed_virtual_text = '40'

 call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
 call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
 call sign_define("LspDiagnosticsInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
 call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

" }}}

" autocompletion {{{

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip'
let g:completion_enable_snippet = 'vim-vsnip'
let g:completion_matching_ignore_case = 1
let g:completion_auto_change_source = 1
let g:completion_confirm_key = ""
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"
" }}}

" vsnip {{{
" Expand
imap <expr> <M-Tab>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<Tab>'
smap <expr> <M-Tab>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<Tab>'

" Expand or jump
"imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
"smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        <C-s>   <Plug>(vsnip-select-text)
xmap        <C-s>   <Plug>(vsnip-select-text)
nmap        <C-S>   <Plug>(vsnip-cut-text)
xmap        <C-S>   <Plug>(vsnip-cut-text)
" }}}

endif

" }}}

" coc.nvim autocomplete options {{{

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

if (!has("nvim-0.5.0"))
  " Give more space for displaying messages.
  set cmdheight=2

  let g:coc_config_home='~/.dotfiles'
  " uncomment this to install extensions automatically
  "let g:coc_global_extensions=['coc-vimlsp', 'coc-ultisnips', 'coc-snippets', 'coc-python', 'coc-json', 'coc-cmake', 'coc-yaml']

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  "inoremap <silent><expr> <TAB>
       "\ pumvisible() ? "\<C-n>" :
       "\ <SID>check_back_space() ? "\<TAB>" :
       "\ coc#refresh()
  "inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  inoremap <silent><expr> <TAB>
        \ coc#jumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
  " position. Coc only does snippet and additional edit on confirm.
  " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
  if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nnoremap <leader>cr :CocRestart<CR>

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  nmap <leader>al  <Plug>(coc-codelens-action)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Organize Imports
  nmap <leader>or :OR<CR>

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	if has('nvim-0.4.0') || has('patch-8.2.0750')
	  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
	  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
	endif

  " Mappings using CoCList:
  " Show all diagnostics.
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" snippets {{{

let g:UltiSnipsExpandTrigger='<M-tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'
" }}}

endif
" }}}

" c++ options {{{

"nmap <leader>am <Plug>AddMissingScope

" map to <Leader>fm in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>fm :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>fm :ClangFormat<CR>

let g:clang_format#detect_style_file = 1

" }}}

" rust options {{{

au FileType rust nmap <leader>fm :RustFmt<CR>

"}}}

" golang vim-go options {{{

let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 0
let g:go_highlight_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

let g:go_auto_sameids = 0
let g:go_fmt_command="goimports"
let g:go_fmt_fail_silently = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 0 " maps gd to <Plug>(go-def)
let g:go_echo_go_info = 0


" disabling gopls because coc.nvim starts this up
let g:go_gopls_enabled = 0
let g:go_def_mode="godef"
let g:go_referrers_mode = 'guru'
let g:go_info_mode = 'guru'
let g:go_debug = []

let g:go_decls_mode = 'fzf'
"let g:go_gopls_options = ['-remote=auto']
" let g:go_list_type = 'quickfix'
let g:go_list_type_commands = {"_guru": "quickfix"}


au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gtf <Plug>(go-test-func)
au FileType go nmap <leader>ga <Plug>(go-alternate-edit)
au FileType go nmap <F1> <Plug>(go-doc)
au FileType go nmap <F6> <Plug>(go-rename)
au FileType go nmap <F7> <Plug>(go-referrers)
au FileType go nmap <F12> :GoDecls<CR>
au FileType go nmap <leader>ge <Plug>(go-iferr)
au FileType go nmap <leader>gfs :GoFillStruct<CR>
" search function name under curser
au FileType go nmap <leader>ff :silent grep '^func ?\(?.*\)? <C-r><C-w>\(' \| cwindow<CR>
" search type under curser
au FileType go nmap <leader>ft :silent grep '^type <C-r><C-w>' \| cwindow<CR>
" change T to (T, error) used for return values when cursor is within T
au FileType go nmap <leader>se ciW(<C-r>-, error)
" change (T, error) to T when cursor is on line and return type is last
" parentheses on line
au FileType go nmap <leader>de $F(lyt,F(df)h"0p
" }}}

" scala options {{{
au FileType scala nmap <leader>ed <Plug>(coc-metals-expand-decoration)
au FileType scala nmap <leader>fm :Format<CR>
"}}}

" python options {{{
au FileType python nmap <leader>fm :Format<CR>
"" }}}

" haskell options {{{
au FileType haskell nmap <leader>fm :%!stylish-haskell<CR>

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
" }}}

" lua {{{
au FileType lua nnoremap <leader>K :help <C-r><C-w><CR>
" }}}

" todo.txt plugins {{{

au BufNewFile,BufRead *.[Tt]odo.txt set filetype=todo
au BufNewFile,BufRead *.[Dd]one.txt set filetype=todo
au filetype todo setlocal omnifunc=todo#Complete
"au filetype todo imap <buffer> + +<C-X><C-O>
"au filetype todo imap <buffer> @ @<C-X><C-O>
au filetype todo nmap <buffer> <localleader>d :call todo#PrioritizeAdd('D')<CR>
au filetype todo nmap <buffer> <localleader>e :call todo#PrioritizeAdd('E')<CR>
au filetype todo nmap <buffer> <localleader>f :call todo#PrioritizeAdd('F')<CR>
au filetype todo nmap <buffer> <localleader>pd :execute "normal mq0df)x`q" \| delmarks q<CR>

let g:TodoTxtForceDoneName='done.txt'
let g:Todo_txt_prefix_creation_date=1
let g:Todo_fold_char='x'
" }}}

" fzf options {{{

let g:fzf_preview_window = ['down:50%', 'ctrl-p']

" }}}

" ale config {{{
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_enabled = 0
let g:ale_linters = {
      \ 'go': ['govet', 'golint', 'gofmt', 'gobuild'],
      \ 'python': ['flake8'],
      \ }
let g:ale_go_golint_options = '-min_confidence=0.6'

"let g:ale_go_golangci_lint_options = ' --fast --tests'
nnoremap <leader>l :ALEToggle<CR>
" }}}

" airline {{{
" Enable integration with airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

"let g:airline_theme = 'gruvbox'
let g:airline_theme = 'oceanicnext'

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
let g:airline_highlighting_cache = 1

" airline tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1


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

" }}}

" general mappings {{{


" edit neovim config
nnoremap <leader>ec :e ~/.config/nvim/init.vim<CR>

" switch to previous buffer then close tab
nnoremap <M-w> :bp\| bd #<CR>

" Allow tab autocomplete

" for moving back to diff file list when using merginal
" to diff branches
" e.g. 'dv' in merginal window to diff file
" then ,d to close diff, buffer and move back to merginal window
"nnoremap <leader>d :q \| bp \| bd # \| wincmd h<CR>

" remaps comma for moving char search backwards (opposite of ; in normal mode)
nnoremap <M-;> ,
" close all windows
nnoremap <C-q> :qa<CR>
nnoremap <M-n> :NERDTreeToggle<CR>
nnoremap <M-S-n> :NERDTreeFind<CR>
nnoremap <M-z> :set wrap!<CR>
nnoremap <M-/> :set hlsearch!<CR>
nnoremap <M-1> :set relativenumber!<CR>
nnoremap <M-c> :cclose<CR>
nnoremap <M-o> <C-o>:bd #<CR>
" copy the current file and line number into clipboard
nnoremap <leader>yl :let @+=expand('%').":".line('.')<CR>
" write the current buffer
nnoremap <leader>w :w<CR>
" reload the current buffer
"nnoremap <leader>re :e!<CR>
" find and replace the word under the cursor
nnoremap <leader>s* :%s/\<<C-r><C-w>\>//g<left><left>
" close other buffers
nnoremap <leader>bo :BufOnly<CR>
" search current word across all files
nnoremap <leader>fw :silent grep '<C-r><C-w>' \| cwindow<CR>
" changing instances of current word
nnoremap <leader>cw :set hlsearch<CR>*Ncgn
" searching for visual selection
vnoremap <leader>/ "vy/\V<C-r>v<CR>
vnoremap * "vy/\<<C-r>v\><CR>
vnoremap # "vy?\<<C-r>v\><CR>
vnoremap g* "vy/<C-r>v<CR>
vnoremap g# "vy?<C-r>v<CR>
" changing instances of visual selection
vnoremap <leader>cw "vy/<C-r>v<CR>Ncgn
" search all files from visual selection
vnoremap <leader>f "vy:silent grep '<C-r>v' \| cwindow<CR>
" find and replace the visual selection
vnoremap <leader>s* "vy:%s/<C-r>v//g<left><left>


" terminal mappings
nnoremap <M-t> :15split \| terminal<CR>
tnoremap <M-Tab> <C-\><C-n>

" window mappings
nnoremap <M-S-k> <C-w>k
nnoremap <M-S-j> <C-w>j
nnoremap <M-S-h> <C-w>h
nnoremap <M-S-l> <C-w>l
nnoremap <M-+> <C-w>+
nnoremap <M-_> <C-w>-
nnoremap <M-<> <C-w><
nnoremap <M->> <C-w>>
nnoremap <M-q> <C-w>q


" quickfix/location list navigation
nnoremap <C-g><C-p> :lprevious<CR>
nnoremap <C-g><C-n> :lnext<CR>
nnoremap gp :cprevious<CR>
nnoremap gn :cnext<CR>

" insert mode mappings
" mapping F12 to something so that it doesnt hang ultisnips
inoremap <F12> <space>


" cmdline mapping
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
" append meeting-"date".md to command line
" for quickly making meeting note files
cnoremap <M-m> -meeting-`date '+\%m\%d\%Y'.md`

"" cmdline abbreviations
"
" so we can use :W to write also
cabbrev W w
" write %% in command line to get the full path of the current buffer
cabbrev <expr> %% expand('%:p:h')

" git mappings
nnoremap <leader>gco :Gcheckout<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gp :Gpush<CR>

" custom fzf functions
" ripgrep search
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --hidden --no-heading --color=always --smart-case '.shellescape(<q-args>), 1, fzf#vim#with_preview("down"), <bang>0)


function! OpenFloatingWin()
  let height = float2nr(&lines * 0.6)
  let width = float2nr(&columns * 0.5)
  let col = float2nr((&columns - width) / 2)
  let row = float2nr((&lines - height) / 2)

  "Set the position, size, etc. of the floating window.
  "The size configuration here may not be so flexible, and there's room for further improvement.
  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col ,
        \ 'width': width,
        \ 'height': height
        \ }

  let buf = nvim_create_buf(v:false, v:true)
  let win = nvim_open_win(buf, v:true, opts)

  "Set Floating Window Highlighting
  call setwinvar(win, '&winhl', 'Normal:Pmenu')

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction

" fzf config
let g:fzf_layout = {'window': 'call OpenFloatingWin()'}

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

if empty(s:get_git_root())
  nnoremap <M-S-p> :Files<CR>
else
  nnoremap <M-S-p> :GFiles<CR>
endif

nnoremap <M-p> :Buffers<CR>

" }}}

" colors {{{


"" Gruvbox
" This HAS to be after plugged :)
let g:gruvbox_contrast_dark='hard'

let base16colorspace=256
set termguicolors
set background=dark
set t_Co=256
"colorscheme gruvbox
colorscheme OceanicNext

" transparent background
"hi Normal guibg=NONE ctermbg=NONE
"hi Pmenu guibg=#180018 ctermbg=234

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
" }}}

" vim-session options {{{
"let g:session_autosave = 'yes'
"let g:session_autosave_periodic = 5
let g:session_persist_colors = 0

" }}}

" autopairs {{{
" disable auto pair shortcuts
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = "<M-'>"
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsMapCR = 1
" }}}

" git messenger config {{{
let g:git_messenger_include_diff = 'current'
let g:git_messenger_always_into_popup = 1
" }}}

" ipython config {{{ "
let g:slime_target = "neovim"
" fix paste issues in ipython
let g:slime_python_ipython = 1

" map <Leader>s to start IPython
nnoremap <Leader>ss :SlimeSend1 ipython<CR>
nnoremap <Leader>pr :SlimeSend1 ipython<CR>
nnoremap <Leader>pr :IPythonCellRun<CR>
nnoremap <Leader>pc :IPythonCellExecuteCell<CR>
nnoremap <Leader>pv :IPythonCellExecuteCellVerbose<CR>
" }}} slime config "

