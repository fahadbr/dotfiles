-- vim:foldmethod=marker

-- general option settings {{{

-- custom functions {{{
function autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

function nmap(key, func, description)
  vim.keymap.set('n', key, func, {desc = description})
end
-- }}}

vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.showmatch = true
vim.o.cursorline = true
vim.o.hidden = true
vim.o.linebreak = true
vim.o.title = true
vim.o.ruler = true
vim.o.autoread = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.signcolumn = 'yes'
vim.o.undolevels = 1000
vim.o.grepprg = 'rg --vimgrep'
vim.o.inccommand = 'nosplit'

-- use vim.opt instead of vim.o when accessing
-- or modifying options in as a table/list
-- see :h vim.opt
vim.opt.mouse:append('a')
vim.opt.backspace = {'indent', 'eol', 'start'}

autocmd({'FocusGained', 'BufEnter'}, {
  pattern = {'*'},
  command = 'checktime'
})

vim.g.mapleader = ','
vim.g.maplocalleader = '-'
-- }}}

-- lazy.nvim (plugins) {{{

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
    vim.keymap.set('n', 'zrr', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zmm', require('ufo').closeAllFolds)
    for i=0,5 do
      local opts = {desc = string.format('open/close all folds with level %d', i)}
      local foldWithLevel = function() require('ufo').closeFoldsWith(i) end
      vim.keymap.set('n', string.format('zr%d', i), foldWithLevel, opts)
      vim.keymap.set('n', string.format('zm%d', i), foldWithLevel, opts)
    end
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

-- conform formatter plugin spec {{{
local conform_plugin = {"stevearc/conform.nvim", config = function()
      local conform = require('conform')
      conform.setup({
        formatters_by_ft = {
          java = {"google-java-format"},
          ["_"] = { "trim_whitespace" }
        },
        formatters = {
          ["google-java-format"] = {
            -- prepend_args = {"--aosp"},
          },
        },
    })
    vim.keymap.set('n', '<leader>fc', conform.format, {desc = "Format Using Conform"})
  end
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

-- nvim-autopairs plugin spec {{{
local nvim_autopairs = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',

  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
  config = true,
}
-- }}}

-- vim-airline plugin spec {{{
local vim_airline = {
  'vim-airline/vim-airline',
  dependencies = {'vim-airline/vim-airline-themes'},
  init = function()
    vim.cmd([[
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
    ]])
  end,
}

-- }}}

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- vimscript
  'scrooloose/nerdtree',
  'Xuyuanp/nerdtree-git-plugin',
  'scrooloose/nerdcommenter',
  {'$HOME/.fzf', dev = true},
  {'$HOME/.dotfiles/fzfc', dev = true},
  'junegunn/fzf.vim',
  'bronson/vim-trailing-whitespace',
  'vim-scripts/BufOnly.vim',
  {'xolox/vim-session', dependencies = {'xolox/vim-misc'}},
  {'tpope/vim-sleuth', priority = 1000},
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'honza/vim-snippets',
  {'inkarkat/vim-ReplaceWithRegister', init = function()
    vim.keymap.set('n', '<leader>r',  '<Plug>ReplaceWithRegisterOperator')
    vim.keymap.set('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine')
    vim.keymap.set('x', '<leader>r',  '<Plug>ReplaceWithRegisterVisual')
  end},
  'AndrewRadev/splitjoin.vim',
  {'fatih/vim-go', ft = 'go'},
  vim_airline,

  -- themes
  {'challenger-deep-theme/vim', name = 'challenger-deep', lazy = true},
  {'fenetikm/falcon', lazy = true},
  {'mhartington/oceanic-next', lazy = true},
  {'jsit/toast.vim', name = 'toast', lazy = true},
  {'morhetz/gruvbox', lazy = true},
  {'rose-pine/neovim', name = 'rose-pine', lazy = false},

  -- lua plugins
  {'williamboman/mason.nvim', config = true},
  {'williamboman/mason-lspconfig.nvim', config = true},
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip',
  'luukvbaal/nnn.nvim',
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'nvim-lua/telescope.nvim',
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  'jose-elias-alvarez/null-ls.nvim',
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}, config = function()
    require('ibl').setup()
  end},
  'voldikss/vim-floaterm',
  'lewis6991/gitsigns.nvim',
  'mfussenegger/nvim-jdtls',
  {'scalameta/nvim-metals', ft = {'scala', 'sbt'}},
  nvim_treesitter_plugin,
  nvim_ufo_plugin,
  conform_plugin,
  nvim_autopairs,
}

require('lazy').setup(plugins)
-- }}}

-- neovim lsp config {{{

-- cmp autocompletion {{{
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
local cmp = require('cmp')
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

-- binding between cmp and autopairs so they play nicely together
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- }}} end cmp config

-- language server configs {{{

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
-- }}}

-- ufo plugin will proxy to vim.lsp.buf.hover() when lines are unfolded
-- telescope lsp pickers will be used in place of
-- - vim.lsp.buf.document_symbol()
-- - vim.lsp.buf.workspace_symbol()
nmap('gd', vim.lsp.buf.definition, 'LSP goto definition')
nmap('gi', vim.lsp.buf.implementation, 'LSP goto implementation')
nmap('<M-k>', vim.lsp.buf.signature_help, 'LSP signature_help')
nmap('1gD', vim.lsp.buf.type_definition, 'LSP type definition')
nmap('gr', vim.lsp.buf.references, 'LSP goto references')
nmap('<M-d>', vim.diagnostic.open_float, 'LSP open floating diagnostics')
nmap('<leader>a', vim.lsp.buf.code_action, 'LSP code action')
nmap('<leader>rn', vim.lsp.buf.rename, 'LSP rename symbol')
nmap('<leader>fm', vim.lsp.buf.format, 'LSP format buffer sync')
nmap('<leader>cr', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end, 'Restart Active LSP Clients')




-- }}} neovim lsp config

-- nvim-jdtls config {{{

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

-- }}}

-- nvim-metals config {{{
local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()


-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
autocmd('FileType', {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { 'scala', 'sbt' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
    nmap('<localleader>m', require('telescope').extensions.metals.commands, 'Show Metals Commands')
  end,
  group = nvim_metals_group,
})


-- }}}

-- telescope {{{
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
nmap('<M-p>', function()
  telescope_builtin.buffers({
    show_all_buffers = false,
    sort_mru = true,
    ignore_current_buffer = true,
  })
end, "List Buffers")
nmap('<space>o', telescope_builtin.lsp_document_symbols, "LSP Document Symbols")
nmap('<space>k', telescope_builtin.keymaps, "Keymaps")
nmap('<leader>fl', live_grep_from_project_git_root, "Live Grep from Git Root")
nmap('<leader>fw', telescope_builtin.grep_string, "Grep String Under Cursor")

-- }}}

-- nnn config {{{
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

nmap('<leader>np', function() vim.cmd.NnnPicker('%:p:h') end, 'Show NnnPicker')
nmap('<leader>ne', function() vim.cmd.NnnExplorer('%:p:h') end, 'Show NnnExplorer')

-- }}} end nnn config

-- gitsigns config {{{
local gitsigns = require('gitsigns')
gitsigns.setup {
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

nmap('<leader>gb', gitsigns.toggle_current_line_blame, 'gitsigns.toggle_current_line_blame')
nmap('<leader>gh', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
nmap('<leader>ga', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
nmap('<leader>g-', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
nmap('<leader>gn', gitsigns.next_hunk, 'gitsigns.next_hunk')
nmap('<leader>gp', gitsigns.prev_hunk, 'gitsigns.prev_hunk')
nmap('<leader>gr', gitsigns.reset_hunk, 'gitsigns.reset_hunk')

-- }}}

-- golang vim-go options {{{

vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_operators = 0
vim.g.go_highlight_types = 1
vim.g.go_highlight_variable_declarations = 1
vim.g.go_highlight_variable_assignments = 1

vim.g.go_auto_sameids = 0
vim.g.go_fmt_command = "goimports"
vim.g.go_fmt_fail_silently = 1
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_code_completion_enabled = 0
vim.g.go_def_mapping_enabled = 0 -- maps gd to <Plug>(go-def)
vim.g.go_echo_go_info = 0

-- disabling gopls because nvim-lspconfig starts this up
vim.g.go_gopls_enabled = 0


local golang_augroup = vim.api.nvim_create_augroup("golang", { clear = true })
autocmd('FileType', {
  pattern = {'go'},
  callback = function()
    nmap('<localleader>gb', '<Plug>(go-build)', '<Plug>(go-build)')
    nmap('<localleader>gtf', '<Plug>(go-test-func)', '<Plug>(go-test-func)')
    nmap('<localleader>ga', '<Plug>(go-alternate-edit)', '<Plug>(go-alternate-edit)')
    nmap('<localleader>ge', '<Plug>(go-iferr)', '<Plug>(go-iferr)')
    nmap('<localleader>gfs', vim.cmd.GoFillStruct, 'GoFillStruct')

    nmap('<localleader>ff', function()
      local word = vim.fn.expand('<cword>')
      vim.cmd([[silent grep '^func ?\(?.*\)? ]] .. word .. [[\(']])
      vim.cmd.cwindow()
    end, 'Search go function name under cursor')

    nmap('<localleader>ft', function()
      local word = vim.fn.expand('<cword>')
      vim.cmd(string.format("silent grep '^type %s'", word))
      vim.cmd.cwindow()
    end, 'Search go type under cursor')

    nmap('<localleader>se',
    'ciW(<C-r>-, error)',
    'change T to (T, error) used for return values when cursor is within T')

    nmap('<localleader>de',
    '$F(lyt,F(df)h"0p',
    'change (T, error) to T when cursor is on line and return type is last parentheses on line')
  end,
  group = golang_augroup,
})
-- }}}

vim.cmd([[
" general mappings {{{

" edit neovim config
nnoremap <leader>ec :e ~/.config/nvim/init.lua<CR>

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

]])