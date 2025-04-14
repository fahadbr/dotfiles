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

      MiniIcons.mock_nvim_web_devicons()
    end
  }
}
