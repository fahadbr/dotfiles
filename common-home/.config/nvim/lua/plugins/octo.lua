-- see lazy plugin spec at
-- https://lazy.folke.io/spec
return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  opts = {
    -- or "fzf-lua" or "snacks" or "default"
    picker = 'telescope',
    -- bare Octo command opens picker of commands
    enable_builtin = true,
    gh_env = {
      GITHUB_API_URL = "https://bbgithub.dev.bloomberg.com/api/v3/",
      GITHUB_GRAPHQL_URL = "https://bbgithub.dev.bloomberg.com/api/graphql"
    }
  },
  keys = {
    {
      '<leader>oi',
      '<CMD>Octo issue list<CR>',
      desc = 'List GitHub Issues',
    },
    {
      '<leader>op',
      '<CMD>Octo pr list<CR>',
      desc = 'List GitHub PullRequests',
    },
    {
      '<leader>od',
      '<CMD>Octo discussion list<CR>',
      desc = 'List GitHub Discussions',
    },
    {
      '<leader>on',
      '<CMD>Octo notification list<CR>',
      desc = 'List GitHub Notifications',
    },
    {
      '<leader>os',
      function()
        require('octo.utils').create_base_search_command({ include_current_repo = true })
      end,
      desc = 'Search GitHub',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- OR "ibhagwan/fzf-lua",
    -- OR "folke/snacks.nvim",
    'nvim-tree/nvim-web-devicons',
  },
}
