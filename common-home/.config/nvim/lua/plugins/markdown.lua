-- see lazy plugin spec at
-- https://lazy.folke.io/spec

vim.g.markdown_folding = 1

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ft = 'markdown',
    opts = {},
  },
  {
    'bullets-vim/bullets.vim',
    init = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit', 'scratch' }
      vim.g.bullets_set_mappings = 0
      vim.g.bullets_custom_mappings = {
        { 'imap', '<cr>', '<Plug>(bullets-newline)' },
        { 'inoremap', '<C-cr>', '<cr>' },
        { 'nmap', 'o', '<Plug>(bullets-newline)' },
        { 'vmap', 'gN', '<Plug>(bullets-renumber)' },
        { 'nmap', 'gN', '<Plug>(bullets-renumber)' },
        { 'nmap', '<C-x>', '<Plug>(bullets-toggle-checkbox)' },
        { 'imap', '<C-t>', '<Plug>(bullets-demote)' },
        { 'nmap', '>>', '<Plug>(bullets-demote)' },
        { 'vmap', '>', '<Plug>(bullets-demote)' },
        { 'imap', '<C-d>', '<Plug>(bullets-promote)' },
        { 'nmap', '<<', '<Plug>(bullets-promote)' },
        { 'vmap', '<', '<Plug>(bullets-promote)' },
      }
    end,
  },
}
