-- vim:foldmethod=marker
-- see lazy plugin spec at
-- https://lazy.folke.io/spec
return {
  {
    'echasnovski/mini.nvim',
    version = '*',
    enabled = true,
    config = function()
      require('mini.trailspace').setup()
      require('mini.splitjoin').setup()
      require('mini.icons').setup()
      require('mini.move').setup({
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          left = 'gH',
          right = 'gL',
          down = 'gJ',
          up = 'gK',

          -- Move current line in Normal mode
          line_left = 'gH',
          line_right = 'gL',
          line_down = 'gJ',
          line_up = 'gK',
        }
      })
      require('mini.align').setup({
        mappings = {
          start = '<leader>ma',
          start_with_preview = '<leader>mA',
        }
      })

      MiniIcons.mock_nvim_web_devicons()
    end
  }
}
