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
set linebreak
set signcolumn=yes

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
Plug '$HOME/.fzf'
Plug '$HOME/.dotfiles/fzfc'
Plug 'junegunn/fzf.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/BufOnly.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'honza/vim-snippets'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'fatih/vim-go'

" themes
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'fenetikm/falcon'
Plug 'mhartington/oceanic-next'
Plug 'jsit/toast.vim', { 'as': 'toast' }
Plug 'morhetz/gruvbox'

" newer neovim plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'luukvbaal/nnn.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'voldikss/vim-floaterm'
Plug 'lewis6991/gitsigns.nvim'
Plug 'scalameta/nvim-metals'


call plug#end()

" }}}

" neovim lsp config {{{
"
" lua config {{{
lua << EOF

-- autocompletion {{{
vim.o.completeopt = 'menuone,noselect'
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- luasnip setup
local luasnip = require('luasnip')
-- load snippets
require("luasnip.loaders.from_snipmate").lazy_load()

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm(),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' }
  },
}

cmp.setup.cmdline('/', {
  sources = {
    name = { 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-- }}}

local lspconfig = require('lspconfig')



-- bash support
lspconfig.bashls.setup{
  capabilities = capabilities
}

-- for c++ support
-- lspconfig.ccls.setup{
--   capabilities = capabilities,
--   init_options = {
--     highlight = {
--       lsRanges = true;
--     }
--   }
-- }

-- for go support
lspconfig.gopls.setup{
  capabilities = capabilities,
  init_options = {
    completeUnimported = true,
    usePlaceholders = true,
    codelenses = {
      gc_details = true,
      test = true
    }
  }
}

lspconfig.pyright.setup{
  capabilities = capabilities
}

-- for lua support
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      underline = true
  }
)

EOF
"}}}

" key mappings {{{
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <M-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <M-d> <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
"nnoremap <silent> <space>o    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> <space>s    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>fm <cmd>lua vim.lsp.buf.format { async = false }<CR>

command! Format execute 'lua vim.lsp.buf.formatting()'


" reload lsp
nnoremap <leader>cr <cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
"}}}

" }}} neovim lsp config

" {{{ nvim-metals config
lua << EOF
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()


-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

EOF

au FileType scala nmap <localleader>m :lua require("telescope").extensions.metals.commands()<CR>
au FileType sbt nmap <localleader>m :lua require("telescope").extensions.metals.commands()<CR>

" }}}

" telescope {{{
lua << EOF
require('telescope').load_extension('fzf')
EOF

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

if empty(s:get_git_root())
  nnoremap <M-S-p> :lua require'telescope.builtin'.find_files()<CR>
else
  nnoremap <M-S-p> :lua require'telescope.builtin'.git_files()<CR>
endif
nnoremap <M-p> :lua require'telescope.builtin'.buffers()<CR>
nnoremap <space>o :lua require'telescope.builtin'.lsp_document_symbols{ path_display = shorten }<CR>
nnoremap <space>s :lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{ path_display = shorten }<CR>
nnoremap <leader>fl :Telescope live_grep<CR>
nnoremap <leader>fw :Telescope grep_string<CR>
" }}}

" {{{ treesitter

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "json", "scala" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- -- the name of the parser)
    -- -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

" }}}

" {{{ nnn config
lua << EOF
require("nnn").setup({
  explorer = {
    width = 35,
  },
  picker = {
    cmd = "tmux new-session nnn",       -- command override (-p flag is implied)
  },
  auto_open = {
    setup = nil,       -- or "explorer" / "picker", auto open on setup function
    tabpage = nil,     -- or "explorer" / "picker", auto open when opening new tabpage
    empty = false,     -- only auto open on empty buffer
    ft_ignore = {      -- dont auto open for these filetypes
      "gitcommit",
    }
  },
  auto_close = true,  -- close tabpage/nvim when nnn is last window
  replace_netrw = nil, -- or "explorer" / "picker"
  mappings = {},       -- table containing mappings, see below
  windownav = {        -- window movement mappings to navigate out of nnn
  left = "<M-S-h>",
  right = "<M-S-l>"
}})
EOF
nnoremap <leader>np :NnnPicker %:p:h<CR>
nnoremap <leader>ne :NnnExplorer<CR>

" }}} end nnn config

" {{{ gitsigns config
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = 'x' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<abbrev_sha>: <author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}
EOF

nnoremap <leader>gb :Gitsigns toggle_current_line_blame<CR>
nnoremap <leader>gh :Gitsigns preview_hunk<CR>
nnoremap <leader>ga :Gitsigns stage_hunk<CR>
nnoremap <leader>g- :Gitsigns undo_stage_hunk<CR>
nnoremap <leader>gn :Gitsigns next_hunk<CR>
nnoremap <leader>gp :Gitsigns prev_hunk<CR>
nnoremap <leader>gr :Gitsigns reset_hunk<CR>
" }}}

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


au FileType go nmap <localleader>gb <Plug>(go-build)
au FileType go nmap <localleader>gtf <Plug>(go-test-func)
au FileType go nmap <localleader>ga <Plug>(go-alternate-edit)
au FileType go nmap <F1> <Plug>(go-doc)
au FileType go nmap <F6> <Plug>(go-rename)
au FileType go nmap <F7> <Plug>(go-referrers)
au FileType go nmap <F12> :GoDecls<CR>
au FileType go nmap <localleader>ge <Plug>(go-iferr)
au FileType go nmap <localleader>gfs :GoFillStruct<CR>
" search function name under curser
au FileType go nmap <localleader>ff :silent grep '^func ?\(?.*\)? <C-r><C-w>\(' \| cwindow<CR>
" search type under curser
au FileType go nmap <localleader>ft :silent grep '^type <C-r><C-w>' \| cwindow<CR>
" change T to (T, error) used for return values when cursor is within T
au FileType go nmap <localleader>se ciW(<C-r>-, error)
" change (T, error) to T when cursor is on line and return type is last
" parentheses on line
au FileType go nmap <localleader>de $F(lyt,F(df)h"0p
" }}}

" lua {{{
au FileType lua nnoremap <leader>K :help <C-r><C-w><CR>
" }}}

" fzf options {{{

let g:fzf_preview_window = ['down:50%', 'ctrl-p']

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
"nnoremap <leader>s* :%s/\<<C-r><C-w>\>//g<left><left>
" close other buffers
nnoremap <leader>bo :BufOnly<CR>
" search current word across all files
"nnoremap <leader>fw :silent grep '<C-r><C-w>' \| cwindow<CR>
" changing instances of current word
nnoremap <leader>cw :set hlsearch<CR>*Ncgn
" searching for visual selection
vnoremap <leader>/ "vy/\V<C-r>v<CR>
vnoremap * "vy/\<<C-r>v\><CR>
vnoremap # "vy?\<<C-r>v\><CR>
vnoremap g* "vy/<C-r>v<CR>
vnoremap g# "vy?<C-r>v<CR>
" changing instances of visual selection
"vnoremap <leader>cw "vy/<C-r>v<CR>Ncgn
" search all files from visual selection
"vnoremap <leader>f "vy:silent grep '<C-r>v' \| cwindow<CR>
" find and replace the visual selection
"vnoremap <leader>s* "vy:%s/<C-r>v//g<left><left>



" window mappings
nnoremap <M-S-k> <C-w>k
nnoremap <M-S-j> <C-w>j
nnoremap <M-S-h> <C-w>h
nnoremap <M-S-l> <C-w>l
nnoremap <M-S-=> 5<C-w>+
nnoremap <M-S--> 5<C-w>-
nnoremap <M-S-,> 5<C-w><
nnoremap <M-S-.> 5<C-w>>
nnoremap <M-+> 5<C-w>+
nnoremap <M-_> 5<C-w>-
nnoremap <M-<> 5<C-w><
nnoremap <M->> 5<C-w>>
nnoremap <M-q> <C-w>q


" quickfix/location list navigation
nnoremap <C-g><C-p> :lprevious<CR>
nnoremap <C-g><C-n> :lnext<CR>
nnoremap gp :cprevious<CR>
nnoremap gn :cnext<CR>

" cmdline mapping
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
" append meeting-"date".md to command line
" for quickly making meeting note files
cnoremap <M-m> -`date '+\%m\%d\%Y'.md`

"" cmdline abbreviations
"
" so we can use :W to write also
cabbrev W w
" write %% in command line to get the full path of the current buffer
cabbrev <expr> %% expand('%:p:h')

" git mappings
nnoremap <leader>lg :FloatermNew --width=0.9 --height=0.95 lazygit<CR>

" }}}

" {{{ Floaterm mappings and options

let g:floaterm_opener = 'edit'

nnoremap <M-t><M-n> :FloatermNew --cwd=<root><CR>
nnoremap <M-t><M-t> :FloatermToggle<CR>
tnoremap <M-t><M-t> <C-\><C-n>:FloatermToggle<CR>
tnoremap <M-t><M-j> <C-\><C-n>:FloatermNext<CR>
tnoremap <M-t><M-k> <C-\><C-n>:FloatermPrev<CR>
tnoremap <M-t><M-q> <C-\><C-n>:FloatermKill<CR>
tnoremap <M-S-t> <C-\><C-n>

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
let g:session_autosave = 'prompt'
"let g:session_autosave_periodic = 5
let g:session_persist_colors = 0
let g:session_autoload = 'no'

" }}}

" autopairs {{{
" disable auto pair shortcuts
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = "<M-'>"
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsMapCR = 1
" }}}
