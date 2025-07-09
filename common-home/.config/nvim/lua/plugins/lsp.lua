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
fr.nmap('<leader>lcr', function()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end, 'LSP Client Restart (restart all active clients)')

return {
  { 'mason-org/mason.nvim' },
  -- nvim-lspconfig {{{
  {
    'neovim/nvim-lspconfig',
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        -- exclude = { 'vue' }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      servers = {
        gopls = {
          init_options = {
            completeUnimported = true,
            usePlaceholders = true,
            codelenses = {
              gc_details = true,
              test = true,
            },
          },
          settings = {
            gopls = {
              gofumpt = true,
            },
          },
        },
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath('config')
                and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
              },
              -- Make the server aware of Neovim runtime files
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add additional paths here.
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },
        yamlls = {
          settings = {
            yaml = {
              redhat = { telemetry = { enabled = false } },
              schemaStore = { enable = true, url = '' },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = function(_, opts)
      if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
        opts.diagnostics.virtual_text.prefix = vim.fn.has('nvim-0.10.0') == 0 and '●'
          or function(diagnostic)
            local icons = LazyVim.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers

      local function setup(server)
        local server_opts = servers[server]
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end


      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            setup(server)
          end
        end
      end
    end,
  },
  -- }}}
  -- mason-lspconfig  {{{

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      automatic_enable = {
        exclude = {
          'jdtls',
        },
      },
    },
  },
  -- }}}
  -- lsp_overloads.nvim {{{
  {
    'Issafalcon/lsp-overloads.nvim',
    event = 'VeryLazy',
    config = function()
      -- parameters dont get highlighted without this
      local labelhl = vim.api.nvim_get_hl_by_name('Function', true)
      vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = labelhl.foreground, italic = true, bold = true })

      vim.lsp.config('*', {
        on_attach = function(client)
          if client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {
              ui = {
                close_events = { 'CursorMoved', 'BufHidden', 'InsertLeave' },
              },
              keymaps = {
                next_signature = '<C-j>',
                previous_signature = '<C-k>',
                next_parameter = '<C-l>',
                previous_parameter = '<C-h>',
                close_signature = '<A-s>',
              },
              display_automatically = true,
            })
          end
        end,
      })
    end,
  },
  -- }}}
}
