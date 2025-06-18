-- vim:foldmethod=marker
--

-- navigation bindings and checks for kitty and tmux {{{
if not fr.in_tmux and not fr.in_kitty then
  fr.nmap('<C-k>', '<C-w>k', 'focus window north')
  fr.nmap('<C-j>', '<C-w>j', 'focus window south')
  fr.nmap('<C-h>', '<C-w>h', 'focus window west')
  fr.nmap('<C-l>', '<C-w>l', 'focus window east')
end

-- }}}

-- general mappings {{{
fr.nmap('<leader>x', function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd('b#') -- Switch to the alternate buffer
  vim.cmd('bd ' .. current_buf) -- Delete the original buffer
end, 'close buffer')

-- remapping <C-l> so it can be used to switch between buffers on the bufferline
fr.nmap('<leader><C-l>', '<C-l>', 'remapping the key to redraw the screen')
-- conflicting with bullet C-d mapping in insert mode. not sure what to map it to right now
-- fr.imap('<C-d>', '<esc>:read !date<CR>kJo', 'insert date into current line (insert)')
fr.nmap('<leader>id', ':read !date<CR>', 'insert date into current line (normal)')
fr.nmap('<leader>Ed', vim.cmd.OpenDailyNote, 'open/edit the daily note')
fr.nmap('<C-q>', ':confirm quitall<CR>', 'close all windows')
fr.nmap('<leader>TW', ':set wrap! | set wrap?<CR>', 'toggle line wrapping')
fr.nmap('<leader>TH', ':set hlsearch! | set hlsearch?<CR>', 'toggle search highlighting')
fr.nmap('<leader>TN', ':set relativenumber! | set relativenumber?<CR>', 'toggle relativenumber')
fr.nmap('yFL', [[:let @+=expand('%').":".line('.')<CR>"]], 'yank/copy the current file and line number into clipboard')
fr.nmap(
  'yFW',
  [[:let @+=expand('%')."::<C-r><C-w>"<CR>"]],
  'yank/copy the current file and word under cursor into clipboard'
)
fr.nmap('<leader>w', vim.cmd.w, 'write current buffer')
fr.nmap('<leader>bp', function()
  print(vim.fn.expand('%'))
end, 'print relative filepath of current buffer')
fr.nmap('<leader>bP', function()
  print(vim.fn.expand('%:p'))
end, 'print absolute filepath of current buffer')
fr.nmap('<leader>cw', ':set hlsearch<CR>*Ncgn', 'change instances of word under cursor (repeat with .)')
-- -- not really used so commented out
-- fr.nmap( '<leader>s*' , ':%s/\<<C-r><C-w>\>//g<left><left>',  'Find and replace word under the cursor')
-- fr.nmap( '<leader>fw' , ':silent grep '<C-r><C-w>' \| cwindow<CR>',  'Search files in rootdir for word under cursor')

-- -- window mappings
-- see vim-kitty-navigator for the next 4 mappings
fr.nmap('<C-Up>', '5<C-w>+', 'increase vertical window size')
fr.nmap('<C-Down>', '5<C-w>-', 'decrease vertical window size')
fr.nmap('<C-Left>', '5<C-w><', 'decrease horizontal window size')
fr.nmap('<C-Right>', '5<C-w>>', 'increase horizontal window size')
fr.nmap('_', '<C-w>s', 'horizontal split')
fr.nmap('|', '<C-w>v', 'vertical split')
--fr.nmap('<M-q>', '<C-w>q', 'close window')
fr.map({ 'i', 'x' }, '<C-k>', '<Esc><C-k>', { desc = 'focus window north', remap = true })
fr.map({ 'i', 'x' }, '<C-j>', '<Esc><C-j>', { desc = 'focus window south', remap = true })
fr.map({ 'i', 'x' }, '<C-h>', '<Esc><C-h>', { desc = 'focus window west', remap = true })
fr.map({ 'i', 'x' }, '<C-l>', '<Esc><C-l>', { desc = 'focus window east', remap = true })

-- -- tab mappings
fr.nmap('<leader>tn', function()
  vim.cmd.tabnew('%')
end, 'tab new')
fr.nmap('<leader>tx', vim.cmd.tabclose, 'tab close')
fr.nmap('<leader>to', vim.cmd.tabonly, 'tab only')
--fr.nmap('<leader>tr', ':BufferLineTabRename ', 'tab rename')

-- -- quickfix/loclist mappings
fr.nmap('<C-g><C-p>', ':cprevious<CR>', 'quickfix previous')
fr.nmap('<C-g><C-n>', ':cnext<CR>', 'quickfix next')

fr.vmap('<leader>/', '"vy/\\V<C-r>v<CR>', 'search for vhighlighted text')
fr.vmap('*', '"vy/\\<<C-r>v\\><CR>', 'search for vhighlighted word')
fr.vmap('#', '"vy?\\<<C-r>v\\><CR>', 'backwards search for vhighlighted word')
fr.vmap('g*', '"vy/<C-r>v<CR>', 'search for vhighlighted word (no word bounds)')
fr.vmap('g#', '"vy?<C-r>v<CR>', 'backwards search for vhighlighted word (no word bounds)')
-- -- this select mode mapping is useful for deleting default snippet text and moving on
fr.smap('<bs>', '<bs>i', 'backspace enters insert mode when in select mode')

-- -- cmdline mapping
fr.cmap('<C-p>', '<Up>', 'cmd up')
fr.cmap('<C-n>', '<Down>', 'cmd down')
fr.cmap('<C-a>', '<Home>', 'cmd return to beginning of line')

-- can use this to replace abbreviations after neovim 0.10 release
vim.keymap.set('ca', 'W', 'w', { desc = '"W" as write alias command' })
vim.keymap.set('ca', '%%', 'expand(\'%:p:h\')', { desc = '%% expands to buffer path in cmdline', expr = true })

-- -- custom commands
-- vim.api.nvim_create_user_command('OpenProject',
--   function(opts)
--     local session_name = opts.fargs[1]
--     --local b = opts.bang and '!' or ''
--     vim.o.titlestring = session_name
--     --vim.api.nvim_exec2(string.format(':OpenSession%s %s', b, session_name), {output = 'true'})
--     local ok, result = pcall(vim.cmd.OpenSession, { args = { session_name }, bang = opts.bang })
--     if not ok then
--       vim.notify(result)
--     end
--   end,
--   {
--     nargs = 1,
--     bang = true
--   }
-- )

-- }}}

-- terminal mappings and options {{{

fr.tmap('<C-t><esc>', '<C-\\><C-n>', 'Exit terminal mode')
fr.tmap('<C-S-h>', '<C-\\><C-n><C-w>h', 'focus window west')
fr.tmap('<C-S-j>', '<C-\\><C-n><C-w>j', 'focus window south')
fr.tmap('<C-S-k>', '<C-\\><C-n><C-w>k', 'focus window north')
fr.tmap('<C-S-l>', '<C-\\><C-n><C-w>l', 'focus window east')
fr.tmap('<C-PageUp>', '<C-\\><C-n><C-PageUp>', 'tab previous (terminal)')
fr.tmap('<C-PageDown>', '<C-\\><C-n><C-PageDown>', 'tab next (terminal)')

-- }}}
