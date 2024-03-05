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

" autopairs {{{
" disable auto pair shortcuts
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = "<M-'>"
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsMapCR = 1
" }}}

" airline {{{
" Enable integration with airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'night_owl'

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
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1

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

" lazy plugin manager {{{
lua << EOF

-- nvim-ufo plugin spec {{{
local nvim_ufo_plugin = {"kevinhwang91/nvim-ufo",
  dependencies = {"kevinhwang91/promise-async"},
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require('ufo')
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set('n', 'gh', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)

    ufo.setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds = {'imports', 'comment'},
      preview = {
      win_config = {
        border = {'', '─', '', '', '', '─', '', ''},
        winhighlight = 'Normal:Folded',
        winblend = 0
      },
      mappings = {
        scrollU = '<C-u>',
        scrollD = '<C-d>',
        jumpTop = '[',
        jumpBot = ']'
      }
      },
    })
  end}
-- }}}

-- conform plugin spec {{{
local conform_plugin = {"stevearc/conform.nvim", opts = {
      formatters_by_ft = {
        java = {"google-java-format"},
        ["_"] = { "trim_whitespace" }
      },
      formatters = {
        ["google-java-format"] = {
          -- prepend_args = {"--aosp"},
        },
      },
  }
}
-- }}}

-- nvim-treesitter plugin spec {{{
local nvim_treesitter_plugin = {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "json",
          "scala",
          "java",
          "yaml",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end}
-- }}}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- vimscript
  "scrooloose/nerdtree",
  "Xuyuanp/nerdtree-git-plugin",
  "scrooloose/nerdcommenter",
  {"vim-airline/vim-airline", dependencies = {"vim-airline/vim-airline-themes"}},
  {"$HOME/.fzf", dev = true},
  {"$HOME/.dotfiles/fzfc", dev = true},
  "junegunn/fzf.vim",
  "bronson/vim-trailing-whitespace",
  "jiangmiao/auto-pairs",
  "vim-scripts/BufOnly.vim",
  {"xolox/vim-session", dependencies = {"xolox/vim-misc"}},
  {"tpope/vim-sleuth", priority = 1000},
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "honza/vim-snippets",
  {"inkarkat/vim-ReplaceWithRegister", init = function()
    vim.keymap.set('n', '<leader>r',  '<Plug>ReplaceWithRegisterOperator')
    vim.keymap.set('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine')
    vim.keymap.set('x', '<leader>r',  '<Plug>ReplaceWithRegisterVisual')
  end},
  "AndrewRadev/splitjoin.vim",
  {"fatih/vim-go", ft = "go"},

  -- themes
  {"challenger-deep-theme/vim", name = "challenger-deep", lazy = true},
  {"fenetikm/falcon", lazy = true},
  {"mhartington/oceanic-next", lazy = true},
  {"jsit/toast.vim", name = "toast", lazy = true},
  {"morhetz/gruvbox", lazy = true},
  {"rose-pine/neovim", name = "rose-pine", lazy = false},

  -- lua plugins
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "luukvbaal/nnn.nvim",
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-lua/telescope.nvim",
  {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
  "jose-elias-alvarez/null-ls.nvim",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, config = function()
    require("ibl").setup()
  end},
  "voldikss/vim-floaterm",
  "lewis6991/gitsigns.nvim",
  "scalameta/nvim-metals",
  "mfussenegger/nvim-jdtls",
  nvim_treesitter_plugin,
  nvim_ufo_plugin,
  conform_plugin,
}

require("lazy").setup(plugins)
EOF
" }}}

" mason config {{{
lua << EOF

require("mason").setup()
require("mason-lspconfig").setup()

EOF
" }}}

" neovim lsp config {{{

" lua config {{{
lua << EOF

-- autocompletion {{{
vim.o.completeopt = 'menuone,noselect'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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

lspconfig.lua_ls.setup {
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
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
" ufo plugin will proxy to this
"nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <M-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <M-d> <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <silent> <leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
" telescope is handling these mappings
"nnoremap <silent> <space>o    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> <space>s    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>fm <cmd>lua vim.lsp.buf.format { async = false }<CR>

command! Format execute 'lua vim.lsp.buf.formatting()'


" reload lsp
nnoremap <leader>cr <cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>
"}}}

" }}} neovim lsp config

" nvim-jdtls config {{{

lua << EOF

local jdtls_setup = require("jdtls.setup")

local home = os.getenv("HOME")
local root_markers = { ".git", "mvnw", "gradlew" }
local root_dir = jdtls_setup.find_root(root_markers)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local mason_pkg_path = home .. "/.local/share/nvim/mason/packages"
local jdtls_path = mason_pkg_path .. "/jdtls"
local lombok_path = jdtls_path .. "/lombok.jar"
-- TODO make config path dependent on system
local config_path = jdtls_path .. "/config_mac_arm"
local launcher_jar_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")


local jdtls_config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1G",
    "-javaagent:" .. lombok_path,
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar_path,
    "-data", workspace_dir,
    "-configuration", config_path,
  },
  cmd_env = {
    GRADLE_HOME = home .. "/.sdkman/candidates/gradle/current/bin/gradle",
  },
}

local nvim_jdtls_group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  callback = function()
    require("jdtls").start_or_attach(jdtls_config)
  end,
  group = nvim_jdtls_group,
})

EOF

" }}}

" nvim-metals config {{{
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
  pattern = { "scala", "sbt" },
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
local telescope = require('telescope')
local telescope_utils = require('telescope.utils')
local telescope_builtin = require('telescope.builtin')
telescope.load_extension('fzf')
telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
    },
    path_display = function(opts, path)
      local tail = telescope_utils.path_tail(path)
      return string.format("%s -- %s", tail, path)
    end,
  },
})

function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

local git_opts = {
  cwd = get_git_root(),
}

-- this function allows finding all files in a git repo
-- even if they havent been added
local function find_files_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = git_opts
  end
  opts.hidden = true
  opts.follow = true

  telescope_builtin.find_files(opts)
end

-- this function will use git ls-files if its a git repo
-- otherwise fallback to find_files
local function git_or_find_files()
  if is_git_repo() then
    telescope_builtin.git_files()
  else
    telescope_builtin.find_files()
  end
end

-- this function will live grep from the git root
-- if in a git repo
local function live_grep_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = git_opts
  end
  telescope_builtin.live_grep(opts)
end

local function nmap(key, func, description)
  vim.keymap.set('n', key, func, {desc = description})
end

nmap('<space>s', telescope_builtin.lsp_dynamic_workspace_symbols, 'LSP Dynamic Workspace Symbols')
nmap('<C-p>', find_files_from_project_git_root, "Find Files From Git Root")
nmap('<M-S-p>', git_or_find_files, "Git or Find Files")
nmap('<M-p>', telescope_builtin.buffers, "List Buffers")
nmap('<space>o', telescope_builtin.lsp_document_symbols, "LSP Document Symbols")
nmap('<space>k', telescope_builtin.keymaps, "Keymaps")
nmap('<leader>fl', live_grep_from_project_git_root, "Live Grep from Git Root")
nmap('<leader>fw', telescope_builtin.grep_string, "Grep String Under Cursor")

EOF
" }}}

" nnn config {{{
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

" gitsigns config {{{
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

" general mappings {{{


" edit neovim config
nnoremap <leader>ec :e ~/.config/nvim/init.vim<CR>

" switch to previous buffer then close tab
nnoremap <M-w> :bp\| bd #<CR>

" insert date
inoremap <C-d> <esc>:read !date<CR>kJA
nnoremap <leader>id :read !date<CR>

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

" floaterm mappings and options {{{

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
colorscheme rose-pine
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

