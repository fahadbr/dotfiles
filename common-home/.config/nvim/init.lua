-- vim:foldmethod=marker

-- adding some global functions
-- under the global 'fr'. using initials
-- to avoid any collisions
_G.fr = require('utils')
require('core')

-- lazy.nvim (plugins) {{{
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ import = 'plugins' })
-- }}}
