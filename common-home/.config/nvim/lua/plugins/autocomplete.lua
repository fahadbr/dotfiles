-- vim:foldmethod=marker
return {
  { 'L3MON4D3/LuaSnip', version = "v2.*", build = "make install_jsregexp" },
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


      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      vim.lsp.config('*', {
        capabilities = capabilities
      })
    end
  },
  -- }}}
}
