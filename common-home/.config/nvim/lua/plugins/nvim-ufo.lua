-- vim:foldmethod=marker
return {
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
}
