-- vim:foldmethod=marker
return {
  -- gitsigns {{{
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup {
        signs                        = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = 'x' },
          untracked    = { text = '┆' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 500,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<abbrev_sha>: <author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }

      fr.nmap('<leader>gb', gitsigns.toggle_current_line_blame, 'gitsigns.toggle_current_line_blame')
      fr.nmap('<leader>gh', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
      fr.nmap('<leader>ga', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
      fr.nmap('<leader>g-', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
      fr.nmap('<leader>gn', gitsigns.next_hunk, 'gitsigns.next_hunk')
      fr.nmap('<leader>gp', gitsigns.prev_hunk, 'gitsigns.prev_hunk')
      fr.nmap('<leader>gr', gitsigns.reset_hunk, 'gitsigns.reset_hunk')
    end
  },
  -- }}}
}
