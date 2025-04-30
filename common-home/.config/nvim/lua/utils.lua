
local kittypid = os.getenv("KITTY_PID")
local tmuxenv = os.getenv("TMUX")
local sshconn = os.getenv("SSH_CONNECTION")
M = {
  in_kitty = kittypid ~= nil and kittypid ~= '',
  in_tmux = tmuxenv ~= nil and tmuxenv ~= '',
  in_ssh = sshconn ~= nil and sshconn ~= '',
}

function M.map(mode, key, mapping, opts)
  if opts.desc == nil and type(mapping) == 'string' then
    opts.desc = mapping
  end
  vim.keymap.set(mode, key, mapping, opts)
end

function M.nmap(key, mapping, description)
  M.map('n', key, mapping, {desc = description})
end

function M.imap(key, mapping, description)
  M.map('i', key, mapping, {desc = description})
end

function M.imap_remap(key, mapping, description, remap)
  M.map('i', key, mapping, {desc = description, remap = remap})
end

function M.vmap(key, mapping, description)
  M.map('v', key, mapping, {desc = description})
end

function M.cmap(key, mapping, description)
  M.map('c', key, mapping, {desc = description})
end

function M.tmap(key, mapping, description)
  M.map('t', key, mapping, {desc = description})
end

function M.xmap(key, mapping, description)
  M.map('x', key, mapping, {desc = description})
end

function M.smap(key, mapping, description)
  M.map('s', key, mapping, {desc = description})
end

function M.autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

function M.dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- merge_copy creates a new table with the results of t2
-- merged into t1, where t2 keys will override t1 keys
function M.merge_copy(t1, t2)
  local result = {}
  for k, v in pairs(t1) do result[k] = v end
  for k, v in pairs(t2) do result[k] = v end
  return result
end

return M
