-- vim:foldmethod=marker
return {
  -- harpoon {{{
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      fr.nmap("<space>ha", function() harpoon:list():add() end, "add to harpoon list")
      fr.nmap("<space>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "show harpoon ui")

      for i = 0, 9 do
        local desc = string.format("Select harpoon list entry %d", i)
        local harpoonSelect = function() harpoon:list():select(i) end
        fr.nmap(string.format("<space>h%d", i), harpoonSelect, desc)
      end

      -- Toggle previous & next buffers stored within Harpoon list
      fr.nmap("<space>hp", function() harpoon:list():prev() end, "Go to prev harpoon buffer")
      fr.nmap("<space>hn", function() harpoon:list():next() end, "Go to next harpoon buffer")
    end
  },
  -- }}}
  -- vim-kitty-navigator  {{{

  {
    'knubie/vim-kitty-navigator',
    cond = in_kitty and not in_tmux,
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
      fr.nmap('<C-S-k>', vim.cmd.KittyNavigateUp, 'focus window up (kitty)')
      fr.nmap('<C-S-j>', vim.cmd.KittyNavigateDown, 'focus window down (kitty)')
      fr.nmap('<C-S-h>', vim.cmd.KittyNavigateLeft, 'focus window left (kitty)')
      fr.nmap('<C-S-l>', vim.cmd.KittyNavigateRight, 'focus window right (kitty)')
    end
  },

  -- }}}
  -- nvim-tmux-navigation {{{
  {
    'alexghergh/nvim-tmux-navigation',
    cond = in_tmux,
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end
  },
  -- }}}
}
