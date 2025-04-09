-- vim:foldmethod=marker
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

return {
  { 'williamboman/mason.nvim', config = true },
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

}
