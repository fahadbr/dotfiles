-- vim:foldmethod=marker
return {
  -- nvim-treesitter  {{{
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ignore_install = {},
        modules = {},
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          -- disabling dockerfile since it keeps giving errors
          disable = { "dockerfile" },
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },
  -- }}}
  -- nvim-treesitter-objects {{{
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = { query = "@function.outer", desc = "Select outer part of function" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of function" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of class" },
              ["aa"] = { query = "@assignment.outer", desc = "Select whole assignment statement" },
              ["ial"] = { query = "@assignment.lhs", desc = "Select left side of assignment statement" },
              ["iar"] = { query = "@assignment.rhs", desc = "Select right side of assignment statement" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
          },
        },
      }
    end
  },
  -- }}}
  -- nvim-ts-autotag {{{
  {
    'windwp/nvim-ts-autotag',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,         -- Auto close tags
          enable_rename = true,        -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
        aliases = {
          ["xsd"] = "xml",
        }
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        -- per_filetype = {
        --   ["html"] = {
        --     enable_close = false
        --   }
        -- }
      }
    end
  },
  -- }}}
}
