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
  vim.cmd('b#')            -- Switch to the alternate buffer
  vim.cmd('bd ' .. current_buf)  -- Delete the original buffer
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

-- HACK: Manage Markdown tasks in Neovim similar to Obsidian | Telescope to List Completed and Pending Tasks
-- https://youtu.be/59hvZl077hM
--
-- If there is no `untoggled` or `done` label on an item, mark it as done
-- and move it to the "## completed tasks" markdown heading in the same file, if
-- the heading does not exist, it will be created, if it exists, items will be
-- appended to it at the top lamw25wmal
--
-- If an item is moved to that heading, it will be added the `done` label
fr.nmap('<C-x>', function()
  -- Customizable variables
  -- NOTE: Customize the completion label
  local label_done = 'done:'
  -- NOTE: Customize the timestamp format
  local timestamp = os.date('%Y-%m-%d')
  -- NOTE: Customize the heading and its level
  local tasks_heading = '## Completed tasks'
  -- Save the view to preserve folds
  vim.cmd('mkview')
  local api = vim.api
  -- Retrieve buffer & lines
  local buf = api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1] - 1
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local total_lines = #lines
  -- If cursor is beyond last line, do nothing
  if start_line >= total_lines then
    vim.cmd('loadview')
    return
  end
  ------------------------------------------------------------------------------
  -- (A) Move upwards to find the bullet line (if user is somewhere in the chunk)
  ------------------------------------------------------------------------------
  while start_line > 0 do
    local line_text = lines[start_line + 1]
    -- Stop if we find a blank line or a bullet line
    if line_text == '' or line_text:match('^%s*%-') then
      break
    end
    start_line = start_line - 1
  end
  -- Now we might be on a blank line or a bullet line
  if lines[start_line + 1] == '' and start_line < (total_lines - 1) then
    start_line = start_line + 1
  end
  ------------------------------------------------------------------------------
  -- (B) Validate that it's actually a task bullet, i.e. '- [ ]' or '- [x]'
  ------------------------------------------------------------------------------
  local bullet_line = lines[start_line + 1]
  if not bullet_line:match('^%s*%- %[[x ]%]') then
    -- Not a task bullet => show a message and return
    print('Not a task bullet: no action taken.')
    vim.cmd('loadview')
    return
  end
  ------------------------------------------------------------------------------
  -- 1. Identify the chunk boundaries
  ------------------------------------------------------------------------------
  local chunk_start = start_line
  local chunk_end = start_line
  while chunk_end + 1 < total_lines do
    local next_line = lines[chunk_end + 2]
    if next_line == '' or next_line:match('^%s*%-') then
      break
    end
    chunk_end = chunk_end + 1
  end
  -- Collect the chunk lines
  local chunk = {}
  for i = chunk_start, chunk_end do
    table.insert(chunk, lines[i + 1])
  end
  ------------------------------------------------------------------------------
  -- 2. Check if chunk has [done: ...] or [untoggled], then transform them
  ------------------------------------------------------------------------------
  local has_done_index = nil
  local has_untoggled_index = nil
  for i, line in ipairs(chunk) do
    -- Replace `[done: ...]` -> `` `done: ...` ``
    chunk[i] = line:gsub('%[done:([^%]]+)%]', '`' .. label_done .. '%1`')
    -- Replace `[untoggled]` -> `` `untoggled` ``
    chunk[i] = chunk[i]:gsub('%[untoggled%]', '`untoggled`')
    if chunk[i]:match('`' .. label_done .. '.-`') then
      has_done_index = i
      break
    end
  end
  if not has_done_index then
    for i, line in ipairs(chunk) do
      if line:match('`untoggled`') then
        has_untoggled_index = i
        break
      end
    end
  end
  ------------------------------------------------------------------------------
  -- 3. Helpers to toggle bullet
  ------------------------------------------------------------------------------
  -- Convert '- [ ]' to '- [x]'
  local function bulletToX(line)
    return line:gsub('^(%s*%- )%[%s*%]', '%1[x]')
  end
  -- Convert '- [x]' to '- [ ]'
  local function bulletToBlank(line)
    return line:gsub('^(%s*%- )%[x%]', '%1[ ]')
  end
  ------------------------------------------------------------------------------
  -- 4. Insert or remove label *after* the bracket
  ------------------------------------------------------------------------------
  local function insertLabelAfterBracket(line, label)
    local prefix = line:match('^(%s*%- %[[x ]%])')
    if not prefix then
      return line
    end
    local rest = line:sub(#prefix + 1)
    return prefix .. ' ' .. label .. rest
  end
  local function removeLabel(line)
    -- If there's a label (like `` `done: ...` `` or `` `untoggled` ``) right after
    -- '- [x]' or '- [ ]', remove it
    return line:gsub('^(%s*%- %[[x ]%])%s+`.-`', '%1')
  end
  ------------------------------------------------------------------------------
  -- 5. Update the buffer with new chunk lines (in place)
  ------------------------------------------------------------------------------
  local function updateBufferWithChunk(new_chunk)
    for idx = chunk_start, chunk_end do
      lines[idx + 1] = new_chunk[idx - chunk_start + 1]
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end
  ------------------------------------------------------------------------------
  -- 6. Main toggle logic
  ------------------------------------------------------------------------------
  if has_done_index then
    chunk[has_done_index] = removeLabel(chunk[has_done_index]):gsub('`' .. label_done .. '.-`', '`untoggled`')
    chunk[1] = bulletToBlank(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], '`untoggled`')
    updateBufferWithChunk(chunk)
    vim.notify('Untoggled', vim.log.levels.INFO)
  elseif has_untoggled_index then
    chunk[has_untoggled_index] =
      removeLabel(chunk[has_untoggled_index]):gsub('`untoggled`', '`' .. label_done .. ' ' .. timestamp .. '`')
    chunk[1] = bulletToX(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], '`' .. label_done .. ' ' .. timestamp .. '`')
    updateBufferWithChunk(chunk)
    vim.notify('Completed', vim.log.levels.INFO)
  else
    -- Save original window view before modifications
    local win = api.nvim_get_current_win()
    local view = api.nvim_win_call(win, function()
      return vim.fn.winsaveview()
    end)
    chunk[1] = bulletToX(chunk[1])
    chunk[1] = insertLabelAfterBracket(chunk[1], '`' .. label_done .. ' ' .. timestamp .. '`')
    updateBufferWithChunk(chunk)
    -- -- Remove chunk from the original lines
    -- for i = chunk_end, chunk_start, -1 do
    --   table.remove(lines, i + 1)
    -- end
    -- -- Append chunk under 'tasks_heading'
    -- local heading_index = nil
    -- for i, line in ipairs(lines) do
    --   if line:match("^" .. tasks_heading) then
    --     heading_index = i
    --     break
    --   end
    -- end
    -- if heading_index then
    --   for _, cLine in ipairs(chunk) do
    --     table.insert(lines, heading_index + 1, cLine)
    --     heading_index = heading_index + 1
    --   end
    --   -- Remove any blank line right after newly inserted chunk
    --   local after_last_item = heading_index + 1
    --   if lines[after_last_item] == "" then
    --     table.remove(lines, after_last_item)
    --   end
    -- else
    --   table.insert(lines, tasks_heading)
    --   for _, cLine in ipairs(chunk) do
    --     table.insert(lines, cLine)
    --   end
    --   local after_last_item = #lines + 1
    --   if lines[after_last_item] == "" then
    --     table.remove(lines, after_last_item)
    --   end
    -- end
    -- Update buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify('Completed', vim.log.levels.INFO)
    -- Restore window view to preserve scroll position
    api.nvim_win_call(win, function()
      vim.fn.winrestview(view)
    end)
  end
  -- Write changes and restore view to preserve folds
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd('silent update')
  vim.cmd('loadview')
end, 'Toggle task and move it to \'done\'')
-- }}}
