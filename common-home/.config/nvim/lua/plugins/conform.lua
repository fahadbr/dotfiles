-- vim:foldmethod=marker
return {
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
}
