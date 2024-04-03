-- vim:foldmethod=marker

-- general option settings {{{

-- custom functions {{{
local function autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

local function map_with_mode(mode, key, mapping, description)
  if description == nil and type(mapping) == 'string' then
    description = mapping
  end
  vim.keymap.set(mode, key, mapping, { desc = description })
end

local function nmap(key, mapping, description)
  map_with_mode('n', key, mapping, description)
end

local function imap(key, mapping, description)
  map_with_mode('i', key, mapping, description)
end

local function vmap(key, mapping, description)
  map_with_mode('v', key, mapping, description)
end

local function cmap(key, mapping, description)
  map_with_mode('c', key, mapping, description)
end

local function tmap(key, mapping, description)
  map_with_mode('t', key, mapping, description)
end

local function make_lsp_capabilities()
  -- lsp capabilities (needs to be defined sooner for other plugins to use)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

-- }}}

vim.g.mapleader = ','
vim.g.maplocalleader = '-'

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
vim.o.termguicolors = true
vim.o.mousemoveevent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.signcolumn = 'yes'
vim.o.undolevels = 1000
vim.o.grepprg = 'rg --vimgrep'
vim.o.inccommand = 'nosplit'
vim.o.background = 'dark'
vim.o.completeopt = 'menuone,noselect'

-- use vim.opt instead of vim.o when accessing
-- or modifying options in as a table/list
-- see :h vim.opt
vim.opt.mouse:append('a')
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.sessionoptions:remove { 'blank' }
vim.opt.sessionoptions:append { 'globals' }

autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = { '*' },
  command = 'checktime'
})
autocmd({ 'Filetype' }, {
  pattern = { 'markdown' },
  callback = function(opts) vim.bo[opts.buf].textwidth = 80 end
})

-- }}}

-- lazy.nvim (plugins) {{{

---- nvim-ufo plugin spec {{{
local nvim_ufo_plugin = {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require('ufo')
    nmap('zR', ufo.openAllFolds, 'Open All Folds')
    nmap('zM', ufo.closeAllFolds, 'Close All Folds')
    nmap('zrr', ufo.openAllFolds, 'Open All Folds')
    nmap('zmm', ufo.closeAllFolds, 'Close All Folds')
    for i = 0, 5 do
      local opts = { desc = string.format('Open/Close all folds with level %d', i) }
      local foldWithLevel = function() require('ufo').closeFoldsWith(i) end
      nmap(string.format('zr%d', i), foldWithLevel, opts)
      nmap(string.format('zm%d', i), foldWithLevel, opts)
    end
    nmap('gh', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)

    ufo.setup({
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = { default = { 'imports', 'comment' } },
      enable_get_fold_virt_text = false,
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
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
  end
}
-- }}}

---- conform formatter plugin spec {{{
local conform_plugin = {
  "stevearc/conform.nvim",
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters_by_ft = {
        java = { "google-java-format" },
        ["_"] = { "trim_whitespace" }
      },
      formatters = {
        ["google-java-format"] = {
          -- prepend_args = {"--aosp"},
        },
      },
    })
    nmap('<leader>fc', function() conform.format { lsp_fallback = true } end, "Format Using Conform")
  end
}
-- }}}

---- nvim-treesitter plugin spec {{{
local nvim_treesitter_plugin = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
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
      ignore_install = {},
      modules = {},
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end
}
-- }}}

---- nvim-autopairs plugin spec {{{
local nvim_autopairs = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',

  -- use opts = {} for passing setup options
  -- this is equalent to setup({}) function
  config = function()
    local npairs = require('nvim-autopairs')
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')
    npairs.setup({})
    -- enables auto pairing of '<' with '>'
    npairs.add_rule(Rule('<', '>'):with_move(cond.done()))
  end,
}
-- }}}

---- vim-airline plugin spec {{{
local vim_airline = {
  'vim-airline/vim-airline',
  dependencies = { 'vim-airline/vim-airline-themes' },
  init = function()
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_theme = 'night_owl'

    local airline_symbols = vim.g.airline_symbols
    if airline_symbols == nil then
      airline_symbols = {}
    end
    airline_symbols.paste = '∥'
    airline_symbols.whitespace = 'Ξ'
    airline_symbols.branch = ''
    airline_symbols.readonly = ''
    airline_symbols.linenr = ''
    vim.g.airline_symbols = airline_symbols
    vim.g.airline_left_sep = ''
    vim.g.airline_left_alt_sep = ''
    vim.g.airline_right_sep = ''
    vim.g.airline_right_alt_sep = ''
    vim.g.airline_highlighting_cache = 1

    -- airline tabline
    vim.g['airline#extensions#tabline#enabled'] = 1
    vim.g['airline#extensions#tabline#tab_nr_type'] = 1
    vim.g['airline#extensions#tabline#buffer_idx_mode'] = 1
    vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
    vim.g['airline#extensions#tabline#fnamemod'] = ':t'
    vim.g['airline#extensions#tabline#fnamecollapse'] = 1

    nmap('<leader>1', '<Plug>AirlineSelectTab1')
    nmap('<leader>2', '<Plug>AirlineSelectTab2')
    nmap('<leader>3', '<Plug>AirlineSelectTab3')
    nmap('<leader>4', '<Plug>AirlineSelectTab4')
    nmap('<leader>5', '<Plug>AirlineSelectTab5')
    nmap('<leader>6', '<Plug>AirlineSelectTab6')
    nmap('<leader>7', '<Plug>AirlineSelectTab7')
    nmap('<leader>8', '<Plug>AirlineSelectTab8')
    nmap('<leader>9', '<Plug>AirlineSelectTab9')
    nmap('<M-l>', '<Plug>AirlineSelectNextTab')
    nmap('<M-h>', '<Plug>AirlineSelectPrevTab')
  end,
}

-- }}}

---- mason-lspconfig plugin spec {{{

local mason_lspconfig_plugin = {
  'williamboman/mason-lspconfig.nvim',
  dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    local mlcfg = require('mason-lspconfig')
    mlcfg.setup()
    mlcfg.setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
      end,
      yamlls = function()
        require('lspconfig').yamlls.setup {
          capabilities = make_lsp_capabilities(),
          settings = {
            yaml = {
              redhat = { telemetry = { enabled = false } },
              schemaStore = { enable = true, url = '' },
            }
          }
        }
      end
    }
  end
}
-- }}}

---- vim-kitty-navigator plugin spec {{{

local vim_kitty_plugin = {
  'knubie/vim-kitty-navigator',
  build = 'cp ./*.py ~/.config/kitty/',
  init = function()
    vim.g.kitty_navigator_no_mappings = 1
    nmap('<M-S-k>', vim.cmd.KittyNavigateUp, 'Focus window up')
    nmap('<M-S-j>', vim.cmd.KittyNavigateDown, 'Focus window down')
    nmap('<M-S-h>', vim.cmd.KittyNavigateLeft, 'Focus window left')
    nmap('<M-S-l>', vim.cmd.KittyNavigateRight, 'Focus window right')
  end
}

-- }}}

---- persisted session plugin spec {{{
local persisted_plugin_spec = {
  "olimorris/persisted.nvim",
  lazy = false, -- make sure the plugin is always loaded at startup
  config = function()
    local persisted = require('persisted')
    persisted.setup({
      telescope = {
        reset_prompt = true,
        mappings = {
          change_branch = '<c-b>',
          copy_session = '<m-c>',
          delete_session = '<c-d>',
        }
      }
    })

    require("telescope").load_extension("persisted")

    local augroup = vim.api.nvim_create_augroup("PersistedHooks", {})
    autocmd({ "User" }, {
      pattern = "PersistedTelescopeLoadPre",
      group = augroup,
      callback = function()
        -- save the currently loaded session using the global variable
        persisted.save({ session = vim.g.persisted_loaded_session })

        -- delete all open buffers
        vim.api.nvim_input("<ESC>:%bd!<CR>")
      end,
    })
    autocmd({ 'User' }, {
      pattern = 'PersistedLoadPost',
      group = augroup,
      callback = function(session)
        -- set the process title to the directory name when a session is loaded
        local dirname = vim.fn.fnamemodify(session.data.dir_path, ':t')
        vim.o.titlestring = dirname
      end,
    })
  end
}
-- }}}

---- lualine plugin spec {{{
local lualine_plugin = {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  config = function()
    -- function used to create a component which will be disabled when
    -- the window is below `width_size`
    local function width(component, width_size)
      return {
        component,
        cond = function()
          return vim.fn.winwidth(0) > width_size
        end
      }
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        always_divide_middle = false,
      },
      extensions = { 'nerdtree', 'quickfix' },
      sections = {
        lualine_a = { 'mode', 'o:titlestring' },
        lualine_b = { width('branch', 120), width('diff', 120), width('diagnostics', 80) },
        lualine_c = { 'filename' },
        lualine_x = { width('encoding', 120), width('fileformat', 120), width('filetype', 120) },
        lualine_y = { width('progress', 120) },
        lualine_z = { width('location', 80) }
      },
    }
  end
}
--}}}

---- nvim-web-devicons spec {{{

local nvim_web_devicons = {
  -- need a nerd font on the system for this
  -- e.g. `brew install font-hack-nerd-font`
  'nvim-tree/nvim-web-devicons',
  config = function()
    require('nvim-web-devicons').setup {
      color_icons = false,
      default = true,
      strict = true,
      override_by_extension = {
        java = {
          icon = "",
          name = "java"
        }
      }
    }
  end
}

--}}}

---- bufferline plugin spec {{{
local bufferline_plugin = {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- this changes the selected tab underline color
    vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#dddddd' })
    local bufferline = require('bufferline')
    bufferline.setup {
      options = {
        themable = true,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin',
        color_icons = false,
        indicator = {
          style = 'underline'
        },
        numbers = 'ordinal',
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        custom_filter = function(buf_num)
          local ft = vim.bo[buf_num].filetype
          if ft == 'qf' or ft == 'help' then
            return false
          end
          return true
        end,
      },
    }

    nmap('<leader>1', function() bufferline.go_to(1, true) end, 'Bufferline goto buffer 1')
    nmap('<leader>2', function() bufferline.go_to(2, true) end, 'Bufferline goto buffer 2')
    nmap('<leader>3', function() bufferline.go_to(3, true) end, 'Bufferline goto buffer 3')
    nmap('<leader>4', function() bufferline.go_to(4, true) end, 'Bufferline goto buffer 4')
    nmap('<leader>5', function() bufferline.go_to(5, true) end, 'Bufferline goto buffer 5')
    nmap('<leader>6', function() bufferline.go_to(6, true) end, 'Bufferline goto buffer 6')
    nmap('<leader>7', function() bufferline.go_to(7, true) end, 'Bufferline goto buffer 7')
    nmap('<leader>8', function() bufferline.go_to(8, true) end, 'Bufferline goto buffer 8')
    nmap('<leader>9', function() bufferline.go_to(9, true) end, 'Bufferline goto buffer 9')
    nmap('<leader>bp', vim.cmd.BufferLinePick, 'Interactively pick the buffer to focus')
    nmap('<leader>bc', vim.cmd.BufferLinePickClose, 'Interactively pick the buffer to close')
    nmap('<leader>bo', vim.cmd.BufferLineCloseOthers, 'Close other buffers')
    nmap('<leader>br', vim.cmd.BufferLineCloseRight, 'Close buffers to the right')
    nmap('<leader>bl', vim.cmd.BufferLineCloseLeft, 'Close buffers to the left')
    nmap('<M-l>', vim.cmd.BufferLineCycleNext, 'Bufferline go to next buffer')
    nmap('<M-h>', vim.cmd.BufferLineCyclePrev, 'bufferline go to previous buffer')
  end,
}
--}}}

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
  { '$HOME/.fzf',           dev = true },
  { '$HOME/.dotfiles/fzfc', dev = true },
  'junegunn/fzf.vim',
  'bronson/vim-trailing-whitespace',
  { 'tpope/vim-sleuth', priority = 1000 },
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'honza/vim-snippets',
  {
    'inkarkat/vim-ReplaceWithRegister',
    init = function()
      nmap('<leader>r', '<Plug>ReplaceWithRegisterOperator')
      nmap('<leader>rr', '<Plug>ReplaceWithRegisterLine')
      map_with_mode('x', '<leader>r', '<Plug>ReplaceWithRegisterVisual')
    end
  },
  'AndrewRadev/splitjoin.vim',
  { 'fatih/vim-go',     ft = 'go' },
  --vim_airline,
  vim_kitty_plugin,

  -- themes
  { 'challenger-deep-theme/vim', name = 'challenger-deep', lazy = true },
  { 'fenetikm/falcon',           lazy = true },
  { 'mhartington/oceanic-next',  lazy = true },
  { 'jsit/toast.vim',            name = 'toast',           lazy = true },
  { 'morhetz/gruvbox',           lazy = true },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme('rose-pine') end,
  },

  -- lua plugins
  { 'williamboman/mason.nvim',                  config = true },
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
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = true
  },
  'voldikss/vim-floaterm',
  'lewis6991/gitsigns.nvim',
  'mfussenegger/nvim-jdtls',
  { 'scalameta/nvim-metals', ft = { 'scala', 'sbt' } },
  nvim_treesitter_plugin,
  nvim_ufo_plugin,
  conform_plugin,
  nvim_autopairs,
  mason_lspconfig_plugin,
  persisted_plugin_spec,
  lualine_plugin,
  nvim_web_devicons,
  bufferline_plugin,
}

require('lazy').setup(plugins)
-- }}}

-- neovim lsp config {{{

-- cmp autocompletion {{{

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
local lsp_capabilities = make_lsp_capabilities()

-- bash support
lspconfig.bashls.setup {
  capabilities = lsp_capabilities
}

-- for go support
lspconfig.gopls.setup {
  capabilities = lsp_capabilities,
  init_options = {
    completeUnimported = true,
    usePlaceholders = true,
    codelenses = {
      gc_details = true,
      test = true
    }
  }
}

lspconfig.pyright.setup {
  capabilities = lsp_capabilities
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
        globals = { 'vim' },
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
-- - vim.lsp.buf.definition()
-- - vim.lsp.buf.implementation()
-- - vim.lsp.buf.references()
-- - vim.lsp.buf.type_definition()
nmap('<M-k>', vim.lsp.buf.signature_help, 'LSP signature_help')
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
    path_display = function(_, path)
      local tail = telescope_utils.path_tail(path)
      return string.format("%s -- %s", tail, path)
    end,
  },
})

local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

local function get_git_root()
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

nmap('gd', telescope_builtin.lsp_definitions, 'LSP goto definition (telescope)')
nmap('gi', telescope_builtin.lsp_implementations, 'LSP goto implementation (telescope)')
nmap('gr', telescope_builtin.lsp_references, 'LSP goto references (telescope)')
nmap('<leader>gd', telescope_builtin.lsp_type_definitions, 'LSP type definition (telescope)')
nmap('<space>s', telescope_builtin.lsp_dynamic_workspace_symbols, 'LSP Dynamic Workspace Symbols (telescope)')
nmap('<C-p>', find_files_from_project_git_root, "Find Files From Git Root (telescope)")
nmap('<M-S-p>', git_or_find_files, "Git or Find Files (telescope)")
nmap('<M-p>', function()
  telescope_builtin.buffers({
    show_all_buffers = false,
    sort_mru = true,
    ignore_current_buffer = true,
  })
end, "List Buffers (telescope)")
nmap('<space>o', telescope_builtin.lsp_document_symbols, "LSP Document Symbols (telescope)")
nmap('<space>k', telescope_builtin.keymaps, "Keymaps (telescope)")
nmap('<leader>fl', live_grep_from_project_git_root, "Live Grep from Git Root (telescope)")
nmap('<leader>fw', telescope_builtin.grep_string, "Grep String Under Cursor (telescope)")
nmap('<space>p', telescope.extensions.persisted.persisted, 'Show Sessions (telescope)')

-- }}}

-- nnn config {{{
require("nnn").setup({
  explorer = {
    width = 35,
  },
  picker = {
    cmd = "tmux new-session nnn", -- command override (-p flag is implied)
  },
  auto_open = {
    setup = nil,   -- or "explorer" / "picker", auto open on setup function
    tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
    empty = false, -- only auto open on empty buffer
    ft_ignore = {  -- dont auto open for these filetypes
      "gitcommit",
    }
  },
  auto_close = true,   -- close tabpage/nvim when nnn is last window
  replace_netrw = nil, -- or "explorer" / "picker"
  mappings = {},       -- table containing mappings, see below
  windownav = {        -- window movement mappings to navigate out of nnn
    left = "<M-S-h>",
    right = "<M-S-l>"
  }
})

nmap('<leader>np', function() vim.cmd.NnnPicker('%:p:h') end, 'Show NnnPicker')
nmap('<leader>ne', function() vim.cmd.NnnExplorer('%:p:h') end, 'Show NnnExplorer')

-- }}} end nnn config

-- gitsigns config {{{
local gitsigns = require('gitsigns')
gitsigns.setup {
  signs                        = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = 'x' },
    untracked    = { text = '┆' },
  },
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<abbrev_sha>: <author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm                         = {
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
  pattern = { 'go' },
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

-- floaterm mappings and options {{{

vim.g.floaterm_opener = 'edit'
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.95

nmap('<M-t><M-n>', ':FloatermNew --cwd=<root><CR>', 'New floating terminal in cwd')
nmap('<M-t><M-t>', ':FloatermToggle<CR>', 'Floaterm Toggle')
nmap('<leader>lg', ':FloatermNew lazygit<CR>', 'Lazygit')
tmap('<M-t><M-t>', '<C-\\><C-n>:FloatermToggle<CR>', 'Floaterm Toggle (terminal)')
tmap('<M-t><M-j>', '<C-\\><C-n>:FloatermNext<CR>', 'FloatermNext (terminal)')
tmap('<M-t><M-k>', '<C-\\><C-n>:FloatermPrev<CR>', 'FloatermPrev (terminal)')
tmap('<M-t><M-q>', '<C-\\><C-n>:FloatermKill<CR>', 'FloatermKill (terminal)')
tmap('<M-S-t>', '<C-\\><C-n>', 'Exit terminal mode')

-- }}}

-- general mappings {{{
nmap('<leader>ec', function() vim.cmd.edit('~/.config/nvim/init.lua') end, 'Edit Neovim Config')
nmap('<M-w>', function()
  vim.cmd.bp()
  vim.cmd.bd('#')
end, 'Close buffer')

imap('<C-d>', '<esc>:read !date<CR>kJA', 'Insert date into current line (insert)')
nmap('<leader>id', ':read !date<CR>', 'Insert date into current line (normal)')
nmap('<M-;>', ',', 'Remaps comma for moving char search backwards (opposite of ; in normal mode)')
nmap('<C-q>', vim.cmd.quitall, 'Close all windows')
nmap('<M-n>', ':NERDTreeToggle<CR>', 'NERDTreeToggle')
nmap('<M-S-n>', ':NERDTreeFind<CR>', 'NERDTreeFind')
nmap('<M-z>', ':set wrap!<CR>', 'Toggle line wrapping')
nmap('<M-/>', ':set hlsearch!<CR>', 'Toggle search highlighting')
nmap('<M-1>', ':set relativenumber!<CR>', 'Toggle relativenumber')
nmap('<M-c>', ':cclose<CR>', 'Close quickfix list')
nmap('<M-o>', '<C-o>:bd #', 'Close buffer and go to previous location')
nmap('<leader>yl', [[:let @+=expand('%').":".line('.')<CR>"]], 'Copy the current file and line number into clipboard')
nmap('<leader>w', vim.cmd.w, 'Write current buffer')
nmap('<leader>cw', ':set hlsearch<CR>*Ncgn', 'Change instances of word under cursor (repeat with .)')
-- not really used so commented out
-- nmap( '<leader>s*' , ':%s/\<<C-r><C-w>\>//g<left><left>',  'Find and replace word under the cursor')
-- nmap( '<leader>fw' , ':silent grep '<C-r><C-w>' \| cwindow<CR>',  'Search files in rootdir for word under cursor')

-- window mappings
-- see vim-kitty-navigator for the next 4 mappings
-- nmap('<M-S-k>', '<C-w>k', 'Focus window north')
-- nmap('<M-S-j>', '<C-w>j', 'Focus window south')
-- nmap('<M-S-h>', '<C-w>h', 'Focus window west')
-- nmap('<M-S-l>', '<C-w>l', 'Focus window east')
nmap('<M-S-=>', '5<C-w>+', 'Increase vertical window size')
nmap('<M-S-->', '5<C-w>-', 'Decrease vertical window size')
nmap('<M-S-,>', '5<C-w><', 'Decrease horizontal window size')
nmap('<M-S-.>', '5<C-w>>', 'Increase horizontal window size')
nmap('<M-+>', '5<C-w>+', 'Increase vertical window size')
nmap('<M-_>', '5<C-w>-', 'Decrease vertical window size')
nmap('<M-<>', '5<C-w><', 'Decrease horizontal window size')
nmap('<M->>', '5<C-w>>', 'Increase horizontal window size')
nmap('<M-q>', '<C-w>q', 'Close window')

-- quickfix/loclist mappings
nmap('<C-g><C-p>', ':lprevious<CR>', 'Loclist previous')
nmap('<C-g><C-n>', ':lnext<CR>', 'Loclist next')
nmap('gp', ':cprevious<CR>', 'Quickfix previous')
nmap('gn', ':cnext<CR>', 'Quickfix next')

vmap('<leader>/', '"vy/\\V<C-r>v<CR>', 'Search for vhighlighted text')
vmap('*', '"vy/\\<<C-r>v\\><CR>', 'Search for vhighlighted word')
vmap('#', '"vy?\\<<C-r>v\\><CR>', 'Backwards search for vhighlighted word')
vmap('g*', '"vy/<C-r>v<CR>', 'Search for vhighlighted word (no word bounds)')
vmap('g#', '"vy?<C-r>v<CR>', 'Backwards search for vhighlighted word (no word bounds)')

-- cmdline mapping
cmap('<C-p>', '<Up>', 'Cmd up')
cmap('<C-n>', '<Down>', 'Cmd down')
cmap('<C-a>', '<Home>', 'Cmd return to beginning of line')

-- -- can use this to replace abbreviations after neovim 0.10 release
-- -- vim.keymap.set('ca', 'W', 'w', { desc = '"W" as write alias command' })
-- -- vim.keymap.set('ca', '%%', "expand('%:p:h')", { desc = '%% expands to buffer path in cmdline', expr = true })

-- -- custom commands
-- vim.api.nvim_create_user_command('OpenProject',
--   function(opts)
--     local session_name = opts.fargs[1]
--     --local b = opts.bang and '!' or ''
--     vim.o.titlestring = session_name
--     --vim.api.nvim_exec2(string.format(':OpenSession%s %s', b, session_name), {output = 'true'})
--     local ok, result = pcall(vim.cmd.OpenSession, { args = { session_name }, bang = opts.bang })
--     if not ok then
--       vim.notify(result)
--     end
--   end,
--   {
--     nargs = 1,
--     bang = true
--   }
-- )

-- }}}

-- misc vimscript options {{{
vim.cmd([[

" cmdline abbreviations {{{
" so we can use :W to write also
cabbrev W w
" write %% in command line to get the full path of the current buffer
cabbrev <expr> %% expand('%:p:h')
" }}}

]])
-- }}}
