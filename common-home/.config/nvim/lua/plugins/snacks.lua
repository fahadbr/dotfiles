-- vim:foldmethod=marker
-- see lazy plugin spec at
-- https://lazy.folke.io/spec
return {
  "folke/snacks.nvim",
  event = 'BufEnter',
  opts = {
    notifier = {
      style = 'fancy'
    },
    lazygit = {},
    indent = {},
    gitbrowse = {
      url_patterns = {
        ["%.bloomberg.com"] = {
          branch = "/tree/{branch}",
          file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
          permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
          commit = "/commit/{commit}",
        }
      }
    },
  },
  keys = {
    { '<leader>lg', function() Snacks.lazygit() end,   desc = 'Lazygit (snacks)' },
    { '<C-t><C-l>', function() Snacks.lazygit() end,   desc = 'Lazygit (snacks)' },
    { '<leader>gB', function() Snacks.gitbrowse() end, mode = {'n', 'x'}, desc = 'Open repo of the active file in the browser' },
    { '<space>H', function() Snacks.notifier.show_history() end, desc = 'show Snacks notifier history' },
  }
}
