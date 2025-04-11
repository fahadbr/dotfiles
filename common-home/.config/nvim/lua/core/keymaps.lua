-- vim:foldmethod=marker
--
-- custom functions {{{
local function map_with_mode(mode, key, mapping, description, remap)
  if description == nil and type(mapping) == 'string' then
    description = mapping
  end
  vim.keymap.set(mode, key, mapping, { desc = description, remap = remap })
end

local function nmap(key, mapping, description)
  map_with_mode('n', key, mapping, description, false)
end

local function imap(key, mapping, description)
  map_with_mode('i', key, mapping, description, false)
end

local function imap_remap(key, mapping, description, remap)
  map_with_mode('i', key, mapping, description, remap)
end

local function vmap(key, mapping, description)
  map_with_mode('v', key, mapping, description, false)
end

local function cmap(key, mapping, description)
  map_with_mode('c', key, mapping, description, false)
end

local function tmap(key, mapping, description)
  map_with_mode('t', key, mapping, description, false)
end

local function xmap(key, mapping, description)
  map_with_mode('x', key, mapping, description, false)
end

local function smap(key, mapping, description)
  map_with_mode('s', key, mapping, description, false)
end
-- }}}

-- navigation bindings and checks for kitty and tmux {{{
local kittypid = os.getenv("KITTY_PID")
local in_kitty = kittypid ~= nil and kittypid ~= ''
local tmuxenv = os.getenv("TMUX")
local in_tmux = tmuxenv ~= nil and tmuxenv ~= ''

if not in_tmux and not in_kitty then
  nmap('<C-k>', '<C-w>k', 'focus window north')
  nmap('<C-j>', '<C-w>j', 'focus window south')
  nmap('<C-h>', '<C-w>h', 'focus window west')
  nmap('<C-l>', '<C-w>l', 'focus window east')
end

-- }}}

-- general mappings {{{
nmap('<leader>x', function()
  vim.cmd.bp()
  vim.cmd.bd('#')
end, 'close buffer')

-- remapping <C-l> so it can be used to switch between buffers on the bufferline
nmap('<leader><C-l>', '<C-l>', 'remapping the key to redraw the screen')
imap('<C-d>', '<esc>:read !date<CR>kJA', 'insert date into current line (insert)')
nmap('<leader>id', ':read !date<CR>', 'insert date into current line (normal)')
nmap('<C-q>', ':confirm quitall<CR>', 'close all windows')
nmap('<leader>TW', ':set wrap!<CR>', 'toggle line wrapping')
nmap('<leader>sh', ':set hlsearch!<CR>', 'toggle search highlighting')
nmap('yFL', [[:let @+=expand('%').":".line('.')<CR>"]], 'yank/copy the current file and line number into clipboard')
nmap('yFW', [[:let @+=expand('%')."::<C-r><C-w>"<CR>"]],
  'yank/copy the current file and word under cursor into clipboard')
nmap('<leader>w', vim.cmd.w, 'write current buffer')
nmap('<leader>bp', function() print(vim.fn.expand('%')) end, 'print relative filepath of current buffer')
nmap('<leader>bP', function() print(vim.fn.expand('%:p')) end, 'print absolute filepath of current buffer')
nmap('<leader>cw', ':set hlsearch<CR>*Ncgn', 'change instances of word under cursor (repeat with .)')
-- -- not really used so commented out
-- nmap( '<leader>s*' , ':%s/\<<C-r><C-w>\>//g<left><left>',  'Find and replace word under the cursor')
-- nmap( '<leader>fw' , ':silent grep '<C-r><C-w>' \| cwindow<CR>',  'Search files in rootdir for word under cursor')

-- -- window mappings
-- see vim-kitty-navigator for the next 4 mappings
nmap('<C-Up>', '5<C-w>+', 'increase vertical window size')
nmap('<C-Down>', '5<C-w>-', 'decrease vertical window size')
nmap('<C-Left>', '5<C-w><', 'decrease horizontal window size')
nmap('<C-Right>', '5<C-w>>', 'increase horizontal window size')
nmap('_', '<C-w>s', 'horizontal split')
nmap('|', '<C-w>v', 'vertical split')
--nmap('<M-q>', '<C-w>q', 'close window')
imap_remap('<C-k>', '<C-o><C-k>', 'focus window north', true)
imap_remap('<C-j>', '<C-o><C-j>', 'focus window south', true)
imap_remap('<C-h>', '<C-o><C-h>', 'focus window west', true)
imap_remap('<C-l>', '<C-o><C-l>', 'focus window east', true)

-- -- tab mappings
nmap('<leader>tn', function() vim.cmd.tabnew('%') end, 'tab new')
nmap('<leader>tx', vim.cmd.tabclose, 'tab close')
nmap('<leader>to', vim.cmd.tabonly, 'tab only')
--nmap('<leader>tr', ':BufferLineTabRename ', 'tab rename')

-- -- quickfix/loclist mappings
nmap('<C-g><C-p>', ':lprevious<CR>', 'loclist previous')
nmap('<C-g><C-n>', ':lnext<CR>', 'loclist next')
nmap('<leader>qp', ':cprevious<CR>', 'quickfix previous')
nmap('<leader>qn', ':cnext<CR>', 'quickfix next')


vmap('<leader>/', '"vy/\\V<C-r>v<CR>', 'search for vhighlighted text')
vmap('*', '"vy/\\<<C-r>v\\><CR>', 'search for vhighlighted word')
vmap('#', '"vy?\\<<C-r>v\\><CR>', 'backwards search for vhighlighted word')
vmap('g*', '"vy/<C-r>v<CR>', 'search for vhighlighted word (no word bounds)')
vmap('g#', '"vy?<C-r>v<CR>', 'backwards search for vhighlighted word (no word bounds)')
-- -- this select mode mapping is useful for deleting default snippet text and moving on
smap('<bs>', '<bs>i', 'backspace enters insert mode when in select mode')

-- -- cmdline mapping
cmap('<C-p>', '<Up>', 'cmd up')
cmap('<C-n>', '<Down>', 'cmd down')
cmap('<C-a>', '<Home>', 'cmd return to beginning of line')

-- can use this to replace abbreviations after neovim 0.10 release
vim.keymap.set('ca', 'W', 'w', { desc = '"W" as write alias command' })
vim.keymap.set('ca', '%%', "expand('%:p:h')", { desc = '%% expands to buffer path in cmdline', expr = true })

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

tmap('<C-t><esc>', '<C-\\><C-n>', 'Exit terminal mode')
tmap('<C-S-h>', '<C-\\><C-n><C-w>h', 'focus window west')
tmap('<C-S-j>', '<C-\\><C-n><C-w>j', 'focus window south')
tmap('<C-S-k>', '<C-\\><C-n><C-w>k', 'focus window north')
tmap('<C-S-l>', '<C-\\><C-n><C-w>l', 'focus window east')
tmap('<C-PageUp>', '<C-\\><C-n><C-PageUp>', 'tab previous (terminal)')
tmap('<C-PageDown>', '<C-\\><C-n><C-PageDown>', 'tab next (terminal)')

-- }}}

