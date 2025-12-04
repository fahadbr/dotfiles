-- vim:foldmethod=marker
return {
  -- conform formatter  {{{
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require('conform')
      conform.setup({
        formatters_by_ft = {
          java = { 'google-java-format' },
          toml = { 'taplo' },
          xml = { 'xmllint' },
          xsd = { 'xmllint' },
          json = { 'jq' },
          sql = { 'pg_format' },
          cpp = { 'clang-format' },
          python = function()
            if vim.fs.root(vim.env.PWD, '.style.yapf') ~= nil then
              return { 'yapf' }
            else
              return { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' }
            end
          end,
          go = { 'golines', 'gofumpt' },
          lua = { 'stylua' },
          ['_'] = { 'trim_whitespace' },
        },
        formatters = {
          xmllint = {
            env = { XMLLINT_INDENT = '    ' },
          },
          golines = {
            args = { '-m', '120' },
          },
          yapf = {
            cwd = require('conform.util').root_file({ '.style.yapf' }),
            require_cwd = true,
          },
        },
      })
      fr.nmap('<leader>fc', function()
        conform.format({ lsp_fallback = true, timeout_ms = 1000 })
      end, 'Format Using Conform')
      fr.vmap('<leader>fc', function()
        conform.format({ lsp_fallback = true, timeout_ms = 1000 })
      end, 'Format Using Conform')
    end,
  },
  -- }}}
}
