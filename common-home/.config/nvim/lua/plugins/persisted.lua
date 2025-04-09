-- vim:foldmethod=marker
return {
  -- persisted session  {{{
  {
    "olimorris/persisted.nvim",
    lazy = false, -- make sure the plugin is always loaded at startup
    config = function()
      local persisted = require('persisted')
      persisted.setup({
        telescope = {
          reset_prompt = true,
          mappings = {
            change_branch = '<c-b>',
            copy_session = '<c-c>',
            delete_session = '<c-d>',
          }
        }
      })

      require("telescope").load_extension("persisted")

      local augroup = vim.api.nvim_create_augroup("PersistedHooks", {})
      fr.autocmd({ "User" }, {
        pattern = "PersistedTelescopeLoadPre",
        group = augroup,
        callback = function()
          -- save the currently loaded session using the global variable
          persisted.save({ session = vim.g.persisted_loaded_session })

          -- delete all open buffers
          vim.api.nvim_input("<ESC>:%bd!<CR>")
        end,
      })

      local function setdirname()
        -- set the process title to the directory name when a session is loaded
        local dir_path = vim.fn.getcwd()

        -- -- not using session.data because for some reason it adds the git branch
        -- -- at the end of the dir_path
        -- if session.data then
        --   dir_path = session.data.dir_path
        -- end

        local dirname = vim.fn.fnamemodify(dir_path, ':t')
        vim.o.titlestring = dirname
      end
      fr.autocmd({ 'User' }, { pattern = 'PersistedLoadPost', group = augroup, callback = setdirname })
      fr.autocmd({ 'User' }, { pattern = 'PersistedSavePost', group = augroup, callback = setdirname })
    end
  },
  -- }}}
}
