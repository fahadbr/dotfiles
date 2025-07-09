-- see lazy plugin spec at
-- https://lazy.folke.io/spec

-- get the current git root directory
local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

-- check if the git_root dir name is contained in the environment varable COPILOT_ENABLED_DIRS
-- this allows to copilot to eagerly load only in certain git repos
local copilot_lazy = true
local enabled_dirs = vim.fn.split(os.getenv('COPILOT_ENABLED_DIRS') or '', ':')
for _, dir in ipairs(enabled_dirs) do
  if git_root:find(dir, 1, true) then
    copilot_lazy = false
  end
end

return {
  {
    'github/copilot.vim',
    lazy = copilot_lazy,
    cmd = {
      'Copilot',
      'Copilot setup',
      'Copilot status',
      'Copilot enable',
      'Copilot disable',
    },
    config = function()
      vim.g.copilot_no_tab_map = true
      fr.map('i', '<C-a>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Accept Copilot suggestion',
      })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    lazy = copilot_lazy,
    -- enabled = false,
    dependencies = {
      'github/copilot.vim',
      {'nvim-lua/plenary.nvim', branch = "master"},
    },
    build = "make tiktoken",
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
    },
    opts = {
      -- debug = true,
      -- proxy = "http://127.0.0.1:8888",
      -- allow_insecure = true,
    },
  },
}
