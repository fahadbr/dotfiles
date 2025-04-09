-- vim:foldmethod=marker
-- see lazy plugin spec at
-- https://lazy.folke.io/spec
return {
  {
    'echasnovski/mini.nvim',
    version = '*',
    enabled = false,
    config = function()
      local notify = require('mini.notify')
      notify.setup()
      vim.notify = notify.make_notify()

    end
  }
}
