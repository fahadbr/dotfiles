-- vim:foldmethod=marker

-- adding some global functions
-- under the global 'fr'. using initials
-- to avoid any collisions
_G.fr = require('utils')
require('core')

-- custom functions {{{

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
  {import = 'plugins'},

  -- lua plugins
  {'nvim-lua/popup.nvim'},
  {'nvim-lua/plenary.nvim'},
  { 'williamboman/mason.nvim', config = true },
  { 'L3MON4D3/LuaSnip',                         version = "v2.*", build = "make install_jsregexp" },
  -- nvim-lspconfig {{{
  {
    'neovim/nvim-lspconfig',
    config = function()
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
      lspconfig.lua_ls.setup {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })
        end,
        settings = {
          Lua = {
          }
        }
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

      -- ufo plugin will proxy to vim.lsp.buf.hover() when lines are unfolded
      -- telescope lsp pickers will be used in place of
      -- - vim.lsp.buf.document_symbol()
      -- - vim.lsp.buf.workspace_symbol()
      -- - vim.lsp.buf.definition()
      -- - vim.lsp.buf.implementation()
      -- - vim.lsp.buf.references()
      -- - vim.lsp.buf.type_definition()
      fr.nmap('<leader>k', vim.lsp.buf.signature_help, 'LSP signature_help')
      fr.imap('<C-k>', vim.cmd.LspOverloadsSignature, 'LSP overloads signature_help')
      --imap('<M-k>', vim.lsp.buf.signature_help, 'LSP signature_help')
      fr.nmap('<leader>ld', vim.diagnostic.open_float, 'LSP open floating diagnostics')
      fr.nmap('<leader>la', vim.lsp.buf.code_action, 'LSP code action')
      fr.vmap('<leader>la', vim.lsp.buf.code_action, 'LSP code action')
      fr.nmap('<leader>lr', vim.lsp.buf.rename, 'LSP rename symbol')
      fr.nmap('<leader>lf', vim.lsp.buf.format, 'LSP format buffer sync')
      fr.nmap('<leader>lcr', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end,
        'LSP Client Restart (restart all active clients)')
    end
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
  -- nvim-autopairs  {{{
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',

    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
    config = function()
      local npairs = require('nvim-autopairs')
      --local Rule = require('nvim-autopairs.rule')
      --local cond = require('nvim-autopairs.conds')
      npairs.setup({})
      -- enables auto pairing of '<' with '>'
      --npairs.add_rule(Rule('<', '>'):with_move(cond.done()))
    end,
  },
  -- }}}
  -- nvim-cmp {{{
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "L3MON4D3/LuaSnip",
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local luasnip = require('luasnip')
      -- load snippets
      require("luasnip.loaders.from_snipmate").lazy_load()


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
    end
  },
  -- }}}
  -- gitsigns {{{
  {
    'lewis6991/gitsigns.nvim',
    config = function()
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

      fr.nmap('<leader>gb', gitsigns.toggle_current_line_blame, 'gitsigns.toggle_current_line_blame')
      fr.nmap('<leader>gh', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
      fr.nmap('<leader>ga', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
      fr.nmap('<leader>g-', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
      fr.nmap('<leader>gn', gitsigns.next_hunk, 'gitsigns.next_hunk')
      fr.nmap('<leader>gp', gitsigns.prev_hunk, 'gitsigns.prev_hunk')
      fr.nmap('<leader>gr', gitsigns.reset_hunk, 'gitsigns.reset_hunk')
    end
  },
  -- }}}
  -- golang vim-go {{{
  {
    'fatih/vim-go',
    ft = 'go',
    config = function()
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
      fr.autocmd('FileType', {
        pattern = { 'go' },
        callback = function()
          fr.nmap('<localleader>gb', '<Plug>(go-build)', '<Plug>(go-build)')
          fr.nmap('<localleader>gtf', '<Plug>(go-test-func)', '<Plug>(go-test-func)')
          fr.nmap('<localleader>ga', '<Plug>(go-alternate-edit)', '<Plug>(go-alternate-edit)')
          fr.nmap('<localleader>ge', '<Plug>(go-iferr)', '<Plug>(go-iferr)')
          fr.nmap('<localleader>gfs', vim.cmd.GoFillStruct, 'GoFillStruct')

          fr.nmap('<localleader>ff', function()
            local word = vim.fn.expand('<cword>')
            vim.cmd([[silent grep '^func ?\(?.*\)? ]] .. word .. [[\(']])
            vim.cmd.cwindow()
          end, 'Search go function name under cursor')

          fr.nmap('<localleader>ft', function()
            local word = vim.fn.expand('<cword>')
            vim.cmd(string.format("silent grep '^type %s'", word))
            vim.cmd.cwindow()
          end, 'Search go type under cursor')

          fr.nmap('<localleader>se',
            'ciW(<C-r>-, error)',
            'change T to (T, error) used for return values when cursor is within T')

          fr.nmap('<localleader>de',
            '$F(lyt,F(df)h"0p',
            'change (T, error) to T when cursor is on line and return type is last parentheses on line')
        end,
        group = golang_augroup,
      })
    end
  },
  -- }}}
  -- rose-pine {{{
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme('rose-pine') end,
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
  -- nvim-treesitter-objects {{{
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of function" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
              ["aa"] = { query = "@assignment.outer", desc = "Select whole assignment statement" },
              ["ial"] = { query = "@assignment.lhs", desc = "Select left side of assignment statement" },
              ["iar"] = { query = "@assignment.rhs", desc = "Select right side of assignment statement" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
          },
        },
      }
    end
  },
  -- }}}
  -- nvim-ts-autotag {{{
  {
    'windwp/nvim-ts-autotag',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,         -- Auto close tags
          enable_rename = true,        -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
        aliases = {
          ["xsd"] = "xml",
        }
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        -- per_filetype = {
        --   ["html"] = {
        --     enable_close = false
        --   }
        -- }
      }
    end
  },
  -- }}}
  -- telescope {{{
  {
    'nvim-lua/telescope.nvim',
    config = function()
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
      fr.nmap('gd', vim.lsp.buf.definition, 'go to definition')
      fr.nmap('gi', function()
        telescope_builtin.lsp_implementations(cursor_layout_opts())
      end, 'lsp goto implementation (telescope)')
      fr.nmap('gr', function()
        telescope_builtin.lsp_references(cursor_layout_opts())
      end, 'lsp goto references (telescope)')
      fr.nmap('<space>ltd', function()
        telescope_builtin.lsp_type_definitions(cursor_layout_opts())
      end, 'lsp type definition (telescope)')
      fr.nmap('<space>lvd', function()
        telescope_builtin.lsp_definitions(fr.merge_copy(cursor_layout_opts(), { jump_type = 'vsplit' }))
      end, 'lsp goto definition vsplit (telescope)')
      fr.nmap('<space>lhd', function()
        telescope_builtin.lsp_definitions(fr.merge_copy(cursor_layout_opts(), { jump_type = 'split' }))
      end, 'lsp goto definition hsplit (telescope)')
      fr.nmap('<space>ls', telescope_builtin.lsp_dynamic_workspace_symbols, 'lsp dynamic workspace symbols (telescope)')
      fr.nmap('<space>a', find_files_from_project_git_root, 'find files from git root (telescope)')
      fr.nmap('<space>f', git_or_find_files, 'git files or find files (telescope)')
      fr.nmap('<space>b', function()
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
      fr.nmap('<space>o',
        function() telescope_builtin.lsp_document_symbols { symbol_width = 60, ignore_symbols = { 'variable', 'field' } } end,
        'lsp document symbols (telescope)')
      fr.nmap('<space>tk', telescope_builtin.keymaps, 'keymaps (telescope)')
      fr.nmap('<space>tt', telescope_builtin.treesitter, 'treesitter (telescope)')
      fr.nmap('<space>tb', telescope_builtin.builtin, 'telescope builtins (telescope)')
      fr.nmap('<space>tr', function() telescope_builtin.resume { cache_index = 1 } end,
        'telescope resume picker (telescope)')

      fr.nmap('<space>sl', live_grep_from_project_git_root, 'live grep from git root (telescope)')
      fr.nmap('<space>sb', current_buffer_fuzzy_find, 'live grep current buffer (telescope)')
      fr.nmap('<space>sw', telescope_builtin.grep_string, 'grep string under cursor (telescope)')
      fr.nmap('<space>tp', telescope.extensions.persisted.persisted, 'show sessions (telescope)')
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
          xsd = { "xmllint" },
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
            args = { "-m", "120" }
          }
        },
      })
      fr.nmap('<leader>fc', function() conform.format { lsp_fallback = true, timeout_ms = 1000 } end, "Format Using Conform")
      fr.vmap('<leader>fc', function() conform.format { lsp_fallback = true, timeout_ms = 1000 } end, "Format Using Conform")
    end
  },
  -- }}}
  -- vim-kitty-navigator  {{{

  {
    'knubie/vim-kitty-navigator',
    cond = in_kitty and not in_tmux,
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
      fr.nmap('<C-S-k>', vim.cmd.KittyNavigateUp, 'focus window up (kitty)')
      fr.nmap('<C-S-j>', vim.cmd.KittyNavigateDown, 'focus window down (kitty)')
      fr.nmap('<C-S-h>', vim.cmd.KittyNavigateLeft, 'focus window left (kitty)')
      fr.nmap('<C-S-l>', vim.cmd.KittyNavigateRight, 'focus window right (kitty)')
    end
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

      fr.nmap("<space>ha", function() harpoon:list():add() end, "add to harpoon list")
      fr.nmap("<space>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "show harpoon ui")

      for i = 0, 9 do
        local desc = string.format("Select harpoon list entry %d", i)
        local harpoonSelect = function() harpoon:list():select(i) end
        fr.nmap(string.format("<space>h%d", i), harpoonSelect, desc)
      end

      -- Toggle previous & next buffers stored within Harpoon list
      fr.nmap("<space>hp", function() harpoon:list():prev() end, "Go to prev harpoon buffer")
      fr.nmap("<space>hn", function() harpoon:list():next() end, "Go to next harpoon buffer")
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
      fr.autocmd({ "User" }, {
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
      fr.autocmd({ 'User' }, { pattern = 'PersistedLoadPost', group = augroup, callback = setdirname })
      fr.autocmd({ 'User' }, { pattern = 'PersistedSavePost', group = augroup, callback = setdirname })
    end
  },
  -- }}}
  -- vim-floaterm {{{
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.g.floaterm_opener = 'edit'
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.95

      fr.nmap('<C-t><C-n>', ':FloatermNew --cwd=<root><CR>', 'New floating terminal in cwd')
      fr.nmap('<C-t><C-t>', ':FloatermToggle<CR>', 'Floaterm Toggle')
      fr.nmap('<leader>lg', ':FloatermNew lazygit<CR>', 'Lazygit')
      fr.tmap('<C-t><C-t>', '<C-\\><C-n>:FloatermToggle<CR>', 'Floaterm Toggle (terminal)')
      fr.tmap('<C-t><C-j>', '<C-\\><C-n>:FloatermNext<CR>', 'FloatermNext (terminal)')
      fr.tmap('<C-t><C-k>', '<C-\\><C-n>:FloatermPrev<CR>', 'FloatermPrev (terminal)')
      fr.tmap('<C-t><C-q>', '<C-\\><C-n>:FloatermKill<CR>', 'FloatermKill (terminal)')
    end
  },
  -- }}}
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
      fr.nmap('zR', ufo.openAllFolds, 'Open All Folds')
      fr.nmap('zM', ufo.closeAllFolds, 'Close All Folds')
      fr.nmap('zrr', ufo.openAllFolds, 'Open All Folds')
      fr.nmap('zmm', ufo.closeAllFolds, 'Close All Folds')
      for i = 0, 5 do
        local desc = string.format('Open/Close all folds with level %d', i)
        local foldWithLevel = function() require('ufo').closeFoldsWith(i) end
        fr.nmap(string.format('zr%d', i), foldWithLevel, desc)
        fr.nmap(string.format('zm%d', i), foldWithLevel, desc)
      end
      fr.nmap('K', function()
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
  -- indent-blankline {{{
    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      config = true
    },
  -- }}}
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
          lualine_c = { { 'filename', path = 1, shortening_target = 40 } },
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

      fr.nmap('g1', function() bufferline.go_to(1, true) end, 'Bufferline goto buffer 1')
      fr.nmap('g2', function() bufferline.go_to(2, true) end, 'Bufferline goto buffer 2')
      fr.nmap('g3', function() bufferline.go_to(3, true) end, 'Bufferline goto buffer 3')
      fr.nmap('g4', function() bufferline.go_to(4, true) end, 'Bufferline goto buffer 4')
      fr.nmap('g5', function() bufferline.go_to(5, true) end, 'Bufferline goto buffer 5')
      fr.nmap('g6', function() bufferline.go_to(6, true) end, 'Bufferline goto buffer 6')
      fr.nmap('g7', function() bufferline.go_to(7, true) end, 'Bufferline goto buffer 7')
      fr.nmap('g8', function() bufferline.go_to(8, true) end, 'Bufferline goto buffer 8')
      fr.nmap('g9', function() bufferline.go_to(9, true) end, 'Bufferline goto buffer 9')
      fr.nmap('g0', function() bufferline.go_to(10, true) end, 'Bufferline goto buffer 10')

      -- prefer using telescope for picking and closing specific buffers
      --nmap('<leader>bf', vim.cmd.BufferLinePick, 'Interactively pick the buffer to focus')
      --nmap('<leader>bcp', vim.cmd.BufferLinePickClose, 'Interactively pick the buffer to close')
      fr.nmap('<leader>bco', vim.cmd.BufferLineCloseOthers, 'Close other buffers/bufonly')
      fr.nmap('<leader>bcr', vim.cmd.BufferLineCloseRight, 'Close buffers to the right')
      fr.nmap('<leader>bcl', vim.cmd.BufferLineCloseLeft, 'Close buffers to the left')
      fr.nmap('gn', vim.cmd.BufferLineCycleNext, 'Bufferline go to next buffer')
      fr.nmap('gp', vim.cmd.BufferLineCyclePrev, 'bufferline go to previous buffer')

      fr.nmap('<leader>tr', ':BufferLineTabRename ', 'tab rename')
    end,
  },
  --}}}
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
}

require('lazy').setup(plugins)
-- }}}

