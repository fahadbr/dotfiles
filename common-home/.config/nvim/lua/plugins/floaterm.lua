-- vim:foldmethod=marker
return {
  -- vim-floaterm {{{
  {
    'voldikss/vim-floaterm',
    enabled = false,
    config = function()
      vim.g.floaterm_opener = 'edit'
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.95

      fr.nmap('<C-t><C-n>', ':FloatermNew --cwd=<root><CR>', 'New floating terminal in cwd')
      fr.nmap('<C-t><C-t>', ':FloatermToggle<CR>', 'Floaterm Toggle')
      fr.tmap('<C-t><C-t>', '<C-\\><C-n>:FloatermToggle<CR>', 'Floaterm Toggle (terminal)')
      fr.tmap('<C-t><C-j>', '<C-\\><C-n>:FloatermNext<CR>', 'FloatermNext (terminal)')
      fr.tmap('<C-t><C-k>', '<C-\\><C-n>:FloatermPrev<CR>', 'FloatermPrev (terminal)')
      fr.tmap('<C-t><C-q>', '<C-\\><C-n>:FloatermKill<CR>', 'FloatermKill (terminal)')

      --fr.nmap('<leader>lg', ':FloatermNew lazygit<CR>', 'Lazygit')
      --fr.nmap('<C-t><C-l>', ':FloatermNew lazygit<CR>', 'Lazygit')
      fr.nmap('<C-t><C-y>', ':FloatermNew yazi<CR>', 'Yazi')
    end
  },
  -- }}}
}
