M = {}

function M.map_with_mode(mode, key, mapping, description, remap)
  if description == nil and type(mapping) == 'string' then
    description = mapping
  end
  vim.keymap.set(mode, key, mapping, { desc = description, remap = remap })
end

function M.nmap(key, mapping, description)
  M.map_with_mode('n', key, mapping, description, false)
end

function M.imap(key, mapping, description)
  M.map_with_mode('i', key, mapping, description, false)
end

function M.imap_remap(key, mapping, description, remap)
  M.map_with_mode('i', key, mapping, description, remap)
end

function M.vmap(key, mapping, description)
  M.map_with_mode('v', key, mapping, description, false)
end

function M.cmap(key, mapping, description)
  M.map_with_mode('c', key, mapping, description, false)
end

function M.tmap(key, mapping, description)
  M.map_with_mode('t', key, mapping, description, false)
end

function M.xmap(key, mapping, description)
  M.map_with_mode('x', key, mapping, description, false)
end

function M.smap(key, mapping, description)
  M.map_with_mode('s', key, mapping, description, false)
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
local function merge_copy(t1, t2)
  local result = {}
  for k, v in pairs(t1) do result[k] = v end
  for k, v in pairs(t2) do result[k] = v end
  return result
end

return M
