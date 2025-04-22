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
        auto_attach = true,
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 500,
          ignore_whitespace = true,
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
        on_attach = function (bufnr)
          local gitsigns = require('gitsigns')
          local function map(key, mapping, desc)
            fr.map({'n'}, key, mapping, {desc = desc, buffer = bufnr})
          end
          map('<leader>ga', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
          map('<leader>gb', gitsigns.blame, 'gitsigns.blame')
          map('<leader>gd', gitsigns.diffthis, 'gitsigns.diffthis')
          map('<leader>gh', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
          map('<leader>gn', gitsigns.next_hunk, 'gitsigns.next_hunk')
          map('<leader>gp', gitsigns.prev_hunk, 'gitsigns.prev_hunk')
          map('<leader>gr', gitsigns.reset_hunk, 'gitsigns.reset_hunk')
          map('<leader>gs', gitsigns.select_hunk, 'gitsigns.select_hunk')
          map('<leader>gtb', gitsigns.toggle_current_line_blame, 'gitsigns.toggle_current_line_blame')
          map('<leader>gtd', gitsigns.toggle_deleted, 'gitsigns.toggle_deleted')
          map('<leader>gtw', gitsigns.toggle_word_diff, 'gitsigns.toggle_word_diff')
          map('<leader>gtl', gitsigns.toggle_linehl, 'gitsigns.toggle_linehl')
          map('<leader>gts', gitsigns.toggle_signs, 'gitsigns.toggle_signs')
          map('<leader>gtn', gitsigns.toggle_numhl, 'gitsigns.toggle_numhl')
          map('<leader>gu', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
          map('<leader>gR', gitsigns.reset_buffer, 'gitsigns.reset_buffer')
          map('<leader>gA', gitsigns.stage_buffer, 'gitsigns.stage_buffer')
        end
      }
          -- local function map(key, mapping, desc)
          --   fr.map({'n'}, key, mapping, {desc = desc, buffer = bufnr})
          -- end
          -- map('<leader>ga', gitsigns.stage_hunk, 'gitsigns.stage_hunk')
          -- map('<leader>gb', gitsigns.blame, 'gitsigns.blame')
          -- map('<leader>gd', gitsigns.diffthis, 'gitsigns.diff_this')
          -- map('<leader>gh', gitsigns.preview_hunk, 'gitsigns.preview_hunk')
          -- map('<leader>gn', gitsigns.next_hunk, 'gitsigns.next_hunk')
          -- map('<leader>gp', gitsigns.prev_hunk, 'gitsigns.prev_hunk')
          -- map('<leader>gr', gitsigns.reset_hunk, 'gitsigns.reset_hunk')
          -- map('<leader>gs', gitsigns.select_hunk, 'gitsigns.select_hunk')
          -- map('<leader>gtb', gitsigns.toggle_current_line_blame, 'gitsigns.toggle_current_line_blame')
          -- map('<leader>gtd', gitsigns.toggle_deleted, 'gitsigns.toggle_deleted')
          -- map('<leader>gtw', gitsigns.toggle_word_diff, 'gitsigns.toggle_word_diff')
          -- map('<leader>gtl', gitsigns.toggle_linehl, 'gitsigns.toggle_linehl')
          -- map('<leader>gts', gitsigns.toggle_signs, 'gitsigns.toggle_signs')
          -- map('<leader>gtn', gitsigns.toggle_numhl, 'gitsigns.toggle_numhl')
          -- map('<leader>gu', gitsigns.undo_stage_hunk, 'gitsigns.undo_stage_hunk')
          -- map('<leader>gR', gitsigns.reset_buffer, 'gitsigns.reset_buffer')
          -- map('<leader>gA', gitsigns.stage_buffer, 'gitsigns.stage_buffer')

    end
  },
  -- }}}
}
