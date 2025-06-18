local DAILY_NOTES_PATH = os.getenv('HOME') .. '/notes/daily/'

local function read_file(path)
  local f = io.open(path, 'r')
  if not f then
    return {}
  end
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

local function write_file(path, lines)
  local f = io.open(path, 'w')
  if not f then
    print('Failed to open ' .. path .. ' for writing.')
    return
  end
  for _, line in ipairs(lines) do
    f:write(line .. '\n')
  end
  f:close()
end

local function group_by_subheading(section)
  local grouped = {}
  local current_heading = ''
  for _, line in ipairs(section) do
    if line:match('^##+ ') then
      current_heading = line
      grouped[current_heading] = grouped[current_heading] or {}
    elseif current_heading ~= '' then
      table.insert(grouped[current_heading], line)
    end
  end
  return grouped
end

local function extract_today_section(lines)
  local today_section = {}
  local in_today = false
  for _, line in ipairs(lines) do
    if line:match('^# +Today') then
      in_today = true
    elseif line:match('^# +[^#]') and in_today then
      break
    elseif in_today then
      table.insert(today_section, line)
    end
  end
  return today_section
end

local function get_most_recent_file(dir)
  local handle = io.popen('ls -t ' .. dir .. ' 2>/dev/null')
  if not handle then
    return nil
  end
  local result = handle:read('*l')
  handle:close()
  if result and result ~= '' then
    return dir .. result
  end
  return nil
end

local function migrate_to_new_daily_note(target_path)
  local target_file_handle = io.open(target_path, 'r')
  if target_file_handle then
    -- if the file exists, we dont need to migrate anything
    target_file_handle:close()
    return
  end

  local source_path = get_most_recent_file(DAILY_NOTES_PATH)
  if not source_path then
    print("no source file found in directory:", DAILY_NOTES_PATH)
  end
  local lines = read_file(source_path)
  if not lines or #lines == 0 then
    print('Source file is empty or missing. path='..source_path .. ', lines=' .. #lines)
    return
  end

  local today_section = extract_today_section(lines)
  local grouped_tasks = group_by_subheading(today_section)

  local yesterday = {}
  local today = {}

  for heading, tasks in pairs(grouped_tasks) do
    local done = {}
    local todo = {}
    for _, task in ipairs(tasks) do
      if task:match('^%- %[[xX]%]') then
        table.insert(done, task)
      elseif task:match('^%- %[ %]') then
        table.insert(todo, task)
      end
    end
    if #done > 0 then
      table.insert(yesterday, heading)
      vim.list_extend(yesterday, done)
    end
    if #todo > 0 then
      table.insert(today, heading)
      vim.list_extend(today, todo)
    end
  end

  local final_lines = { '# Yesterday' }
  vim.list_extend(final_lines, yesterday)
  table.insert(final_lines, '')
  table.insert(final_lines, '# Today')
  vim.list_extend(final_lines, today)

  write_file(target_path, final_lines)

  -- delete the source buffer if its open
  local filepath = vim.fn.expand(source_path)
  -- Check if buffer is already loaded
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == filepath then
      -- Buffer loaded, but not visible — open in current window
      vim.api.nvim_buf_delete(buf, {})
      break
    end
  end
end

vim.api.nvim_create_user_command('Grep', function(opts)
  local args = table.concat(opts.fargs, ' ')
  vim.cmd('silent! grep! ' .. args)
  vim.cmd('cwindow')
end, {
  nargs = '+',
  complete = 'file',
})

vim.api.nvim_create_user_command('OpenDailyNote', function()
  local date = os.date('%Y-%m-%d-%A') .. '.md'
  local filepath = vim.fn.expand(DAILY_NOTES_PATH .. date)
  -- Check if buffer is already loaded
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_buf_is_loaded(buf) then
      goto continue
    end
    if vim.api.nvim_buf_get_name(buf) == filepath then
      -- Find window displaying the buffer
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      -- Buffer loaded, but not visible — open in current window
      vim.api.nvim_set_current_buf(buf)
      return
    end
    ::continue::
  end

  migrate_to_new_daily_note(filepath)
  -- Not loaded yet — open the file
  vim.cmd('edit ' .. filepath)
end, {})

