-- vim:foldmethod=marker
return {
  -- lualine  {{{
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      -- function used to create a component which will be disabled when
      -- the window is below `width_size`
      local function width(component, width_size)
        return {
          component,
          cond = function()
            return vim.fn.winwidth(0) > width_size
          end
        }
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          always_divide_middle = false,
        },
        extensions = { 'nerdtree', 'quickfix' },
        sections = {
          lualine_a = { 'mode', 'o:titlestring' },
          lualine_b = { width('branch', 160), width('diff', 160), width('diagnostics', 80) },
          lualine_c = { { 'filename', path = 1, shortening_target = 40 } },
          lualine_x = { width('encoding', 160), width('fileformat', 160), width('filetype', 160) },
          lualine_y = { width('progress', 120) },
          lualine_z = { width('location', 80) }
        },
        inactive_sections = {
          lualine_a = { { 'o:titlestring', separator = { left = '', right = '' }, color = { fg = '#cccccc', bg = '#555555' } } },
          lualine_b = {},
          lualine_c = { { 'filename', path = 4 } },
          lualine_x = { { 'location', separator = { left = '', right = '' }, color = { fg = '#cccccc', bg = '#555555' } } },
          lualine_y = {},
          lualine_z = {},
        }
      }
    end
  },
  --}}}
  -- bufferline  {{{
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      -- this changes the selected tab underline color
      vim.api.nvim_set_hl(0, 'TabLineSel', { bg = '#dddddd' })
      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          themable = true,
          diagnostics = 'nvim_lsp',
          separator_style = 'thin',
          color_icons = false,
          max_name_length = 30,
          max_prefix_length = 20,
          indicator = {
            style = 'underline'
          },
          numbers = 'ordinal',
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },
          custom_filter = function(buf_num)
            local ft = vim.bo[buf_num].filetype
            if ft == 'qf' or ft == 'help' then
              return false
            end
            return true
          end,
        },
      }

      fr.nmap('g1', function() bufferline.go_to(1, true) end, 'Bufferline goto buffer 1')
      fr.nmap('g2', function() bufferline.go_to(2, true) end, 'Bufferline goto buffer 2')
      fr.nmap('g3', function() bufferline.go_to(3, true) end, 'Bufferline goto buffer 3')
      fr.nmap('g4', function() bufferline.go_to(4, true) end, 'Bufferline goto buffer 4')
      fr.nmap('g5', function() bufferline.go_to(5, true) end, 'Bufferline goto buffer 5')
      fr.nmap('g6', function() bufferline.go_to(6, true) end, 'Bufferline goto buffer 6')
      fr.nmap('g7', function() bufferline.go_to(7, true) end, 'Bufferline goto buffer 7')
      fr.nmap('g8', function() bufferline.go_to(8, true) end, 'Bufferline goto buffer 8')
      fr.nmap('g9', function() bufferline.go_to(9, true) end, 'Bufferline goto buffer 9')
      fr.nmap('g0', function() bufferline.go_to(10, true) end, 'Bufferline goto buffer 10')

      -- prefer using telescope for picking and closing specific buffers
      --nmap('<leader>bf', vim.cmd.BufferLinePick, 'Interactively pick the buffer to focus')
      --nmap('<leader>bcp', vim.cmd.BufferLinePickClose, 'Interactively pick the buffer to close')
      fr.nmap('<leader>bco', vim.cmd.BufferLineCloseOthers, 'Close other buffers/bufonly')
      fr.nmap('<leader>bcr', vim.cmd.BufferLineCloseRight, 'Close buffers to the right')
      fr.nmap('<leader>bcl', vim.cmd.BufferLineCloseLeft, 'Close buffers to the left')
      fr.nmap('gn', vim.cmd.BufferLineCycleNext, 'Bufferline go to next buffer')
      fr.nmap('gp', vim.cmd.BufferLineCyclePrev, 'bufferline go to previous buffer')

      fr.nmap('<leader>tr', ':BufferLineTabRename ', 'tab rename')
    end,
  },
  --}}}
}
