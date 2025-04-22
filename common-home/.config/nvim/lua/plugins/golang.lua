-- vim:foldmethod=marker
return {
  -- golang vim-go {{{
  {
    'fatih/vim-go',
    ft = 'go',
    config = function()

      vim.g.go_auto_sameids = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_fmt_autosave = 1
      vim.g.go_fmt_command = "gofumpt"
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
}
