local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local M = {}

local function java_class_snippet_internal()
  return {
    t('class '),
    d(1, function()
      return sn(nil, { i(1, vim.fn.expand('%:t:r')) })
    end, nil),
    t(' {'),
    i(2),
    t('}'),
  }
end

local java_snippets = {

  s({ trig = 'cl', docstring = 'class ${1:$filename} {$0}' }, java_class_snippet_internal()),

  s('pkg', {
    t('package '),
    f(function()
      local path = vim.fn.expand('%:p:h')
      local pkgpath = string.match(path, '.*/src/%w+/java/(.*)')
      if pkgpath == nil then
        return vim.fn.expand('%:p:h:t')
      end
      local pkg = string.gsub(pkgpath, '/', '.')
      return pkg
    end),
    t({ ';', '', '' }),
    sn(1, java_class_snippet_internal())
  }),

  s('psf', fmt('private static final {} {} = {};', { i(1, 'type'), i(2, 'CONSTANT'), i(3, 'value') })),
  s('pusf', fmt('public static final {} {} = {};', { i(1, 'type'), i(2, 'CONSTANT'), i(3, 'value') })),
}

function M.load()
  ls.env_namespace("MY", { vars = { FILENAME = function() vim.fn.expand('%:t:r') end } })
  ls.add_snippets('java', java_snippets)
end

return M
