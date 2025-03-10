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

local function xmap(key, mapping, description)
  map_with_mode('x', key, mapping, description)
end

local function smap(key, mapping, description)
  map_with_mode('s', key, mapping, description)
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

local function dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- merge_copy creates a new table with the results of t2
-- merged into t1, where t2 keys will override t1 keys
local function merge_copy(t1, t2)
  local result = {}
  for k, v in pairs(t1) do result[k] = v end
  for k, v in pairs(t2) do result[k] = v end
  return result
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
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
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

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 250 })
  end,
  group = highlight_group,
})

-- }}}

-- navigation bindings and checks for kitty and tmux {{{
local kittypid = os.getenv("KITTY_PID")
local in_kitty = kittypid ~= nil and kittypid ~= ''
local tmuxenv = os.getenv("TMUX")
local in_tmux = tmuxenv ~= nil and tmuxenv ~= ''

if not in_tmux and not in_kitty then
  nmap('<C-k>', '<C-w>k', 'focus window north')
  nmap('<C-j>', '<C-w>j', 'focus window south')
  nmap('<C-h>', '<C-w>h', 'focus window west')
  nmap('<C-l>', '<C-w>l', 'focus window east')
end

-- }}}

-- lazy.nvim (plugins) {{{

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
  { '.fzf',                      dev = true,               dir = "~" },
  'junegunn/fzf.vim',
  'bronson/vim-trailing-whitespace',
  {
    'tpope/vim-sleuth',
    init = function() vim.g.sleuth_java_heuristics = 0 end,
    priority = 1000
  },
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
  { 'fatih/vim-go',              ft = 'go' },

  -- themes
  { 'challenger-deep-theme/vim', name = 'challenger-deep', lazy = true },
  { 'fenetikm/falcon',           lazy = true },
  { 'mhartington/oceanic-next',  lazy = true },
  { 'jsit/toast.vim',            name = 'toast',           lazy = true },
  { 'morhetz/gruvbox',           lazy = true },
  -- rose-pine {{{
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme('rose-pine') end,
  },
  -- }}}

  -- lua plugins
  { 'williamboman/mason.nvim', config = true },
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
  { 'L3MON4D3/LuaSnip',        version = "v2.*", build = "make install_jsregexp" },
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
  --'mfussenegger/nvim-jdtls',
  --{ 'nvim-java/nvim-java',                      config = true,          main = 'java' },
  --{ 'scalameta/nvim-metals',                    ft = { 'scala', 'sbt' } },
  -- nvim-ufo  {{{
  {
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
        local desc = string.format('Open/Close all folds with level %d', i)
        local foldWithLevel = function() require('ufo').closeFoldsWith(i) end
        nmap(string.format('zr%d', i), foldWithLevel, desc)
        nmap(string.format('zm%d', i), foldWithLevel, desc)
      end
      nmap('K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, 'peak fold (ufo) or lsp hover')

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
  },
  -- }}}
  -- conform formatter  {{{
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require('conform')
      conform.setup({
        formatters_by_ft = {
          java = { "google-java-format" },
          toml = { "toml" },
          xml = { "xmllint" },
          json = { "jq" },
          sql = { "pg_format" },
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports", "yapf" },
          go = { "golines" },
          ["_"] = { "trim_whitespace" },
        },
        formatters = {
          toml = {
            command = "prettier",
            args = { "--plugin", "prettier-plugin-toml", "$FILENAME" }
          },
          xmllint = {
            env = { XMLLINT_INDENT = "    " }
          },
          golines = {
            args = { "-m", "120"}
          }
        },
      })
      nmap('<leader>fc', function() conform.format { lsp_fallback = true, timeout_ms = 1000 } end, "Format Using Conform")
      vmap('<leader>fc', function() conform.format { lsp_fallback = true, timeout_ms = 1000 } end, "Format Using Conform")
    end
  },
  -- }}}
  -- nvim-treesitter  {{{
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "c",
          "cpp",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "json",
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
          -- disabling dockerfile since it keeps giving errors
          disable = { "dockerfile" },
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },
  -- }}}
  -- nvim-autopairs  {{{
  {
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
  },
  -- }}}
  -- mason-lspconfig  {{{

  {
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
        -- ignoring jdtls because of the setup thats happening later in the file
        -- eventually it might be best to move the set up here
        --jdtls = function() end,
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
  },
  -- }}}
  -- vim-kitty-navigator  {{{

  {
    'knubie/vim-kitty-navigator',
    cond = in_kitty and not in_tmux,
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
      nmap('<C-S-k>', vim.cmd.KittyNavigateUp, 'focus window up (kitty)')
      nmap('<C-S-j>', vim.cmd.KittyNavigateDown, 'focus window down (kitty)')
      nmap('<C-S-h>', vim.cmd.KittyNavigateLeft, 'focus window left (kitty)')
      nmap('<C-S-l>', vim.cmd.KittyNavigateRight, 'focus window right (kitty)')
    end
  },

  -- }}}
  -- persisted session  {{{
  {
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    config = function()
      local persisted = require('persisted')
      persisted.setup({
        telescope = {
          reset_prompt = true,
          mappings = {
            change_branch = '<c-b>',
            copy_session = '<c-c>',
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

      local function setdirname()
        -- set the process title to the directory name when a session is loaded
        local dir_path = vim.fn.getcwd()

        -- -- not using session.data because for some reason it adds the git branch
        -- -- at the end of the dir_path
        -- if session.data then
        --   dir_path = session.data.dir_path
        -- end

        local dirname = vim.fn.fnamemodify(dir_path, ':t')
        vim.o.titlestring = dirname
      end
      autocmd({ 'User' }, { pattern = 'PersistedLoadPost', group = augroup, callback = setdirname })
      autocmd({ 'User' }, { pattern = 'PersistedSavePost', group = augroup, callback = setdirname })
    end
  },
  -- }}}
  -- lualine  {{{
  {
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
          lualine_b = { width('branch', 160), width('diff', 160), width('diagnostics', 80) },
          lualine_c = { { 'filename', path = 4 } },
          lualine_x = { width('encoding', 160), width('fileformat', 160), width('filetype', 160) },
          lualine_y = { width('progress', 120) },
          lualine_z = { width('location', 80) }
        },
        inactive_sections = {
          lualine_a = { { 'o:titlestring', separator = { left = '', right = '' }, color = { fg = '#cccccc', bg = '#555555' } } },
          lualine_b = {},
          lualine_c = { { 'filename', path = 4 } },
          lualine_x = { { 'location', separator = { left = '', right = '' }, color = { fg = '#cccccc', bg = '#555555' } } },
          lualine_y = {},
          lualine_z = {},
        }
      }
    end
  },
  --}}}
  -- nvim-web-devicons {{{
  {
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
  },

  --}}}
  -- bufferline  {{{
  {
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
          max_name_length = 30,
          max_prefix_length = 20,
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

      nmap('g1', function() bufferline.go_to(1, true) end, 'Bufferline goto buffer 1')
      nmap('g2', function() bufferline.go_to(2, true) end, 'Bufferline goto buffer 2')
      nmap('g3', function() bufferline.go_to(3, true) end, 'Bufferline goto buffer 3')
      nmap('g4', function() bufferline.go_to(4, true) end, 'Bufferline goto buffer 4')
      nmap('g5', function() bufferline.go_to(5, true) end, 'Bufferline goto buffer 5')
      nmap('g6', function() bufferline.go_to(6, true) end, 'Bufferline goto buffer 6')
      nmap('g7', function() bufferline.go_to(7, true) end, 'Bufferline goto buffer 7')
      nmap('g8', function() bufferline.go_to(8, true) end, 'Bufferline goto buffer 8')
      nmap('g9', function() bufferline.go_to(9, true) end, 'Bufferline goto buffer 9')
      nmap('g0', function() bufferline.go_to(10, true) end, 'Bufferline goto buffer 10')

      -- prefer using telescope for picking and closing specific buffers
      --nmap('<leader>bf', vim.cmd.BufferLinePick, 'Interactively pick the buffer to focus')
      --nmap('<leader>bcp', vim.cmd.BufferLinePickClose, 'Interactively pick the buffer to close')
      nmap('<leader>bco', vim.cmd.BufferLineCloseOthers, 'Close other buffers/bufonly')
      nmap('<leader>bcr', vim.cmd.BufferLineCloseRight, 'Close buffers to the right')
      nmap('<leader>bcl', vim.cmd.BufferLineCloseLeft, 'Close buffers to the left')
      nmap('gn', vim.cmd.BufferLineCycleNext, 'Bufferline go to next buffer')
      nmap('gp', vim.cmd.BufferLineCyclePrev, 'bufferline go to previous buffer')
    end,
  },
  --}}}
  -- lsp_overloads.nvim {{{
  {
    'Issafalcon/lsp-overloads.nvim',
    event = 'VeryLazy',
    config = function()
      -- parameters dont get highlighted without this
      local labelhl = vim.api.nvim_get_hl_by_name('Function', true)
      vim.api.nvim_set_hl(0,
        "LspSignatureActiveParameter",
        { fg = labelhl.foreground, italic = true, bold = true })
    end
  },
  -- }}}
  -- whichkey.nvim {{{
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- }}}
  -- harpoon {{{
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      nmap("<space>ha", function() harpoon:list():add() end, "add to harpoon list")
      nmap("<space>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "show harpoon ui")

      for i = 0, 9 do
        local desc = string.format("Select harpoon list entry %d", i)
        local harpoonSelect = function() harpoon:list():select(i) end
        nmap(string.format("<space>h%d", i), harpoonSelect, desc)
      end

      -- Toggle previous & next buffers stored within Harpoon list
      nmap("<space>hp", function() harpoon:list():prev() end, "Go to prev harpoon buffer")
      nmap("<space>hn", function() harpoon:list():next() end, "Go to next harpoon buffer")
    end
  },
  -- }}}
  -- nvim-tmux-navigation {{{
  {
    'alexghergh/nvim-tmux-navigation',
    cond = in_tmux,
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end
  },
  -- }}}
  -- nvim-treesitter-objects {{{
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-tmux-navigation').setup {
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            include_surrounding_whitespace = true,
          },
        },
      }
    end
  }
  -- }}}
}

require('lazy').setup(plugins)
-- }}}

-- neovim lsp config {{{

-- cmp autocompletion {{{

-- luasnip setup
local luasnip = require('luasnip')
-- load snippets
require("luasnip.loaders.from_snipmate").lazy_load()
require("custom_snippets").load()


-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  preselect = cmp.PreselectMode.None,
  performance = {
    max_view_entries = 20
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 'c', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 'c', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}
local common_cmp_mappings = {
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm(),
  ['<Tab>'] = cmp.mapping.select_next_item(),
  ['<S-Tab>'] = cmp.mapping.select_prev_item(),
}

cmp.setup.cmdline(':', {
  mapping = common_cmp_mappings,
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-- binding between cmp and autopairs so they play nicely together
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- }}} end cmp config

-- language server configs {{{

local lspconfig = require('lspconfig')
local lsp_capabilities = make_lsp_capabilities()
local function on_attach(client)
  if client.server_capabilities.signatureHelpProvider then
    require('lsp-overloads').setup(client, {
      ui = {
        close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
      },
      keymaps = {
        next_signature = "<C-j>",
        previous_signature = "<C-k>",
        next_parameter = "<C-l>",
        previous_parameter = "<C-h>",
        close_signature = "<A-s>"
      },
      display_automatically = true
    })
  end
end

-- jdtls lspconfig setup through nvim-java
-- make sure require('java').setup() is called before this
-- lazy is handling this for us
--lspconfig.jdtls.setup({})

-- bash support
lspconfig.bashls.setup {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
}

-- for go support
lspconfig.gopls.setup {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
  init_options = {
    completeUnimported = true,
    usePlaceholders = true,
    codelenses = {
      gc_details = true,
      test = true
    },
  },
  settings = {
    gopls = {
      gofumpt = true
    }
  }
}

lspconfig.pyright.setup {
  capabilities = lsp_capabilities,
  on_attach = on_attach,
}

-- for lua support
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup {
  on_attach = on_attach,
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
nmap('<leader>k', vim.lsp.buf.signature_help, 'LSP signature_help')
imap('<C-k>', vim.cmd.LspOverloadsSignature, 'LSP overloads signature_help')
--imap('<M-k>', vim.lsp.buf.signature_help, 'LSP signature_help')
nmap('<leader>ld', vim.diagnostic.open_float, 'LSP open floating diagnostics')
nmap('<leader>la', vim.lsp.buf.code_action, 'LSP code action')
vmap('<leader>la', vim.lsp.buf.code_action, 'LSP code action')
nmap('<leader>lr', vim.lsp.buf.rename, 'LSP rename symbol')
nmap('<leader>lf', vim.lsp.buf.format, 'LSP format buffer sync')
nmap('<leader>lcr', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end,
  'LSP Client Restart (restart all active clients)')




-- }}} neovim lsp config

-- nvim-jdtls config {{{

--local jdtls_setup = require("jdtls.setup")

--local home = os.getenv("HOME")
--local root_markers = { ".git", "mvnw", "gradlew" }
--local root_dir = jdtls_setup.find_root(root_markers)
--local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
--local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

--local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

--local mason_pkg_path = home .. "/.local/share/nvim/mason/packages"
--local jdtls_path = mason_pkg_path .. "/jdtls"
--local lombok_path = jdtls_path .. "/lombok.jar"
---- TODO make config path dependent on system
--local config_path = jdtls_path .. "/config_mac_arm"
--local launcher_jar_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")


--local jdtls_config = {
--cmd = {
--install_path .. "/bin/jdtls",
--"--jvm-arg=-javaagent:" .. install_path .. "/lombok.jar",
--"-data", workspace_dir
--},
--cmd_env = {
--GRADLE_HOME = home .. "/.sdkman/candidates/gradle/current/bin/gradle",
--},
--on_attach = function(client)
--if client.server_capabilities.signatureHelpProvider then
--require('lsp-overloads').setup(client, {
--ui = {
--close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
--},
--keymaps = {
--next_signature = "<C-j>",
--previous_signature = "<C-k>",
--next_parameter = "<C-l>",
--previous_parameter = "<C-h>",
--close_signature = "<A-s>"
--},
--display_automatically = true
--})
--end
--end
--}

--local nvim_jdtls_group = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
--vim.api.nvim_create_autocmd("FileType", {
--pattern = { "java" },
--callback = function()
--vim.bo.shiftwidth = 2
--vim.bo.tabstop = 2
--vim.bo.softtabstop = 2
--vim.bo.expandtab = true
--require("jdtls").start_or_attach(jdtls_config)
--end,
--group = nvim_jdtls_group,
--})

-- }}}

-- nvim-metals config {{{
--local metals_config = require("metals").bare_config()

---- Example of settings
--metals_config.settings = {
--showImplicitArguments = true,
--excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
--}

---- Example if you are using cmp how to make sure the correct capabilities for snippets are set
--metals_config.capabilities = make_lsp_capabilities()
--metals_config.on_attach = on_attach


---- Autocmd that will actually be in charging of starting the whole thing
--local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
--autocmd('FileType', {
---- NOTE: You may or may not want java included here. You will need it if you
---- want basic Java support but it may also conflict if you are using
---- something like nvim-jdtls which also works on a java filetype autocmd.
--pattern = { 'scala', 'sbt' },
--callback = function()
--require('metals').initialize_or_attach(metals_config)
--nmap('<localleader>m', require('telescope').extensions.metals.commands, 'Show Metals Commands')
--end,
--group = nvim_metals_group,
--})


-- }}}

-- telescope {{{
local telescope = require('telescope')
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
    layout_strategy = 'flex',
    path_display = { 'filename_first' },
    mappings = {
      n = {
        ["<leader>p"] = {
          require('telescope.actions.layout').toggle_preview,
          type = "action",
        }
      },
      i = {
        ['<C-o>'] = {
          function() telescope_builtin.resume({ cache_index = 1 }) end,
          opts = { desc = 'resume last telescope picker' },
        },
      }
    },
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

local function maybe_get_git_opts()
  local opts = {
    preview = {
      hide_on_startup = true,
    },
  }
  if is_git_repo() then
    opts.cwd = get_git_root()
  end
  return opts
end



-- this function allows finding all files in a git repo
-- even if they havent been added
local function find_files_from_project_git_root()
  local opts = maybe_get_git_opts()
  opts.hidden = true
  opts.follow = true
  telescope_builtin.find_files(opts)
end

-- this function will use git ls-files if its a git repo
-- otherwise fallback to find_files
local function git_or_find_files()
  local opts = maybe_get_git_opts()
  if is_git_repo() then
    telescope_builtin.git_files(opts)
  else
    telescope_builtin.find_files(opts)
  end
end

-- this function will live grep from the git root
-- if in a git repo
local function live_grep_from_project_git_root()
  local opts = maybe_get_git_opts()
  opts.preview.hide_on_startup = false
  telescope_builtin.live_grep(opts)
end

local function current_buffer_fuzzy_find()
  telescope_builtin.current_buffer_fuzzy_find {
    results_title = vim.fn.expand('%'),
  }
end

local function cursor_layout_opts()
  return {
    layout_strategy = 'cursor',
    layout_config = { height = 0.4, width = 180, preview_width = 100, preview_cutoff = 120 }
  }
end

-- telescope version has been buggy
-- nmap('gd', function()
--   telescope_builtin.lsp_definitions(cursor_layout_opts)
-- end, 'lsp goto definition (telescope)')
nmap('gd', vim.lsp.buf.definition, 'go to definition')
nmap('gi', function()
  telescope_builtin.lsp_implementations(cursor_layout_opts())
end, 'lsp goto implementation (telescope)')
nmap('gr', function()
  telescope_builtin.lsp_references(cursor_layout_opts())
end, 'lsp goto references (telescope)')
nmap('<space>ltd', function()
  telescope_builtin.lsp_type_definitions(cursor_layout_opts())
end, 'lsp type definition (telescope)')
nmap('<space>lvd', function()
  telescope_builtin.lsp_definitions(merge_copy(cursor_layout_opts(), { jump_type = 'vsplit' }))
end, 'lsp goto definition vsplit (telescope)')
nmap('<space>lhd', function()
  telescope_builtin.lsp_definitions(merge_copy(cursor_layout_opts(), { jump_type = 'split' }))
end, 'lsp goto definition hsplit (telescope)')
nmap('<space>ls', telescope_builtin.lsp_dynamic_workspace_symbols, 'lsp dynamic workspace symbols (telescope)')
nmap('<space>a', find_files_from_project_git_root, 'find files from git root (telescope)')
nmap('<space>f', git_or_find_files, 'git files or find files (telescope)')
nmap('<space>b', function()
  telescope_builtin.buffers({
    show_all_buffers = true,
    sort_mru = true,
    ignore_current_buffer = true,
    results_title = vim.fn.expand('%'),
    preview = {
      hide_on_startup = false,
    },
    attach_mappings = function(_, map)
      map({ 'i', 'n' }, '<C-x>', 'delete_buffer', { desc = 'close selected buffers' })
      map({ 'i', 'n' }, '<C-s>', 'select_horizontal', { desc = 'open selection in a horizontal split' })
      return true
    end,
  })
end, 'list buffers (telescope)')
nmap('<space>o',
  function() telescope_builtin.lsp_document_symbols { symbol_width = 60, ignore_symbols = { 'variable', 'field' } } end,
  'lsp document symbols (telescope)')
nmap('<space>tk', telescope_builtin.keymaps, 'keymaps (telescope)')
nmap('<space>tt', telescope_builtin.treesitter, 'treesitter (telescope)')
nmap('<space>tb', telescope_builtin.builtin, 'telescope builtins (telescope)')
nmap('<space>tr', function() telescope_builtin.resume { cache_index = 1 } end, 'telescope resume picker (telescope)')

nmap('<leader>fl', live_grep_from_project_git_root, 'DEPRECATED live grep from git root (telescope)')
nmap('<leader>fb', current_buffer_fuzzy_find, 'DEPRECATED live grep current buffer (telescope)')
nmap('<leader>fw', telescope_builtin.grep_string, 'DEPRECATED grep string under cursor (telescope)')
nmap('<space>sl', live_grep_from_project_git_root, 'live grep from git root (telescope)')
nmap('<space>sb', current_buffer_fuzzy_find, 'live grep current buffer (telescope)')
nmap('<space>sw', telescope_builtin.grep_string, 'grep string under cursor (telescope)')
nmap('<space>tp', telescope.extensions.persisted.persisted, 'show sessions (telescope)')

-- }}}

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

-- terminal mappings and options {{{

vim.g.floaterm_opener = 'edit'
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.95

nmap('<C-t><C-n>', ':FloatermNew --cwd=<root><CR>', 'New floating terminal in cwd')
nmap('<C-t><C-t>', ':FloatermToggle<CR>', 'Floaterm Toggle')
nmap('<leader>lg', ':FloatermNew lazygit<CR>', 'Lazygit')
tmap('<C-t><C-t>', '<C-\\><C-n>:FloatermToggle<CR>', 'Floaterm Toggle (terminal)')
tmap('<C-t><C-j>', '<C-\\><C-n>:FloatermNext<CR>', 'FloatermNext (terminal)')
tmap('<C-t><C-k>', '<C-\\><C-n>:FloatermPrev<CR>', 'FloatermPrev (terminal)')
tmap('<C-t><C-q>', '<C-\\><C-n>:FloatermKill<CR>', 'FloatermKill (terminal)')
tmap('<C-t><esc>', '<C-\\><C-n>', 'Exit terminal mode')
tmap('<C-S-h>', '<C-\\><C-n><C-w>h', 'focus window west')
tmap('<C-S-j>', '<C-\\><C-n><C-w>j', 'focus window south')
tmap('<C-S-k>', '<C-\\><C-n><C-w>k', 'focus window north')
tmap('<C-S-l>', '<C-\\><C-n><C-w>l', 'focus window east')
tmap('<C-PageUp>', '<C-\\><C-n><C-PageUp>', 'tab previous (terminal)')
tmap('<C-PageDown>', '<C-\\><C-n><C-PageDown>', 'tab next (terminal)')

-- }}}

-- general mappings {{{
nmap('<leader>ec', function() vim.cmd.edit('~/.config/nvim/init.lua') end, 'edit neovim config')
nmap('<leader>x', function()
  vim.cmd.bp()
  vim.cmd.bd('#')
end, 'close buffer')

-- remapping <C-l> so it can be used to switch between buffers on the bufferline
nmap('<leader><C-l>', '<C-l>', 'remapping the key to redraw the screen')
imap('<C-d>', '<esc>:read !date<CR>kJA', 'insert date into current line (insert)')
nmap('<leader>id', ':read !date<CR>', 'insert date into current line (normal)')
nmap('<C-q>', ':confirm quitall<CR>', 'close all windows')
nmap('<leader>nt', ':NERDTreeToggle<CR>', 'nerdtreetoggle')
nmap('<leader>nf', ':NERDTreeFind<CR>', 'nerdtreefind')
nmap('<leader>TW', ':set wrap!<CR>', 'toggle line wrapping')
nmap('<leader>sh', ':set hlsearch!<CR>', 'toggle search highlighting')
--nmap('<M-c>', ':cclose<CR>', 'close quickfix list')
nmap('<BS>', '<C-o>:bd #<CR>', 'close buffer and go to previous location')
nmap('<leader>yl', [[:let @+=expand('%').":".line('.')<CR>"]], 'copy the current file and line number into clipboard')
nmap('<leader>w', vim.cmd.w, 'write current buffer')
nmap('<leader>bp', function() print(vim.fn.expand('%')) end, 'print relative filepath of current buffer')
nmap('<leader>bP', function() print(vim.fn.expand('%:p')) end, 'print absolute filepath of current buffer')
nmap('<leader>cw', ':set hlsearch<CR>*Ncgn', 'change instances of word under cursor (repeat with .)')
-- -- not really used so commented out
-- nmap( '<leader>s*' , ':%s/\<<C-r><C-w>\>//g<left><left>',  'Find and replace word under the cursor')
-- nmap( '<leader>fw' , ':silent grep '<C-r><C-w>' \| cwindow<CR>',  'Search files in rootdir for word under cursor')

-- -- window mappings
-- see vim-kitty-navigator for the next 4 mappings
nmap('<C-Up>', '5<C-w>+', 'increase vertical window size')
nmap('<C-Down>', '5<C-w>-', 'decrease vertical window size')
nmap('<C-Left>', '5<C-w><', 'decrease horizontal window size')
nmap('<C-Right>', '5<C-w>>', 'increase horizontal window size')
nmap('_', '<C-w>s', 'horizontal split')
nmap('|', '<C-w>v', 'vertical split')
--nmap('<M-q>', '<C-w>q', 'close window')

-- -- tab mappings
nmap('<leader>tn', function() vim.cmd.tabnew('%') end, 'tab new')
nmap('<leader>tc', vim.cmd.tabclose, 'tab close')
nmap('<leader>to', vim.cmd.tabonly, 'tab only')
nmap('<leader>tr', ':BufferLineTabRename ', 'tab rename')

-- -- quickfix/loclist mappings
nmap('<C-g><C-p>', ':lprevious<CR>', 'loclist previous')
nmap('<C-g><C-n>', ':lnext<CR>', 'loclist next')
nmap('<leader>qp', ':cprevious<CR>', 'quickfix previous')
nmap('<leader>qn', ':cnext<CR>', 'quickfix next')

vmap('<leader>/', '"vy/\\V<C-r>v<CR>', 'search for vhighlighted text')
vmap('*', '"vy/\\<<C-r>v\\><CR>', 'search for vhighlighted word')
vmap('#', '"vy?\\<<C-r>v\\><CR>', 'backwards search for vhighlighted word')
vmap('g*', '"vy/<C-r>v<CR>', 'search for vhighlighted word (no word bounds)')
vmap('g#', '"vy?<C-r>v<CR>', 'backwards search for vhighlighted word (no word bounds)')
-- -- this select mode mapping is useful for deleting default snippet text and moving on
smap('<bs>', '<bs>i', 'backspace enters insert mode when in select mode')

-- -- cmdline mapping
cmap('<C-p>', '<Up>', 'cmd up')
cmap('<C-n>', '<Down>', 'cmd down')
cmap('<C-a>', '<Home>', 'cmd return to beginning of line')

-- can use this to replace abbreviations after neovim 0.10 release
vim.keymap.set('ca', 'W', 'w', { desc = '"W" as write alias command' })
vim.keymap.set('ca', '%%', "expand('%:p:h')", { desc = '%% expands to buffer path in cmdline', expr = true })

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

-- }}}
