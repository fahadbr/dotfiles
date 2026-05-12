return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require('nvim-treesitter').setup {}
      vim.treesitter.language.register('xml', 'xsd')
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = "main",
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
      }
      local select_fn = function(query, query_group)
        query_group = query_group or 'textobjects'
        return function()
          require('nvim-treesitter-textobjects.select').select_textobject(query, query_group)
        end
      end
      local maps = {
        ["af"] = { "@function.outer", desc = "Select outer part of function" },
        ["if"] = { "@function.inner", desc = "Select inner part of function" },
        ["ac"] = { "@class.outer", desc = "Select outer part of class" },
        ["aa"] = { "@assignment.outer", desc = "Select whole assignment statement" },
        ["ial"] = { "@assignment.lhs", desc = "Select left side of assignment" },
        ["iar"] = { "@assignment.rhs", desc = "Select right side of assignment" },
        ["ic"] = { "@class.inner", desc = "Select inner part of class" },
      }
      for key, val in pairs(maps) do
        vim.keymap.set({ 'x', 'o' }, key, select_fn(val[1]), { desc = val.desc })
      end
      vim.keymap.set({ 'x', 'o' }, 'as', select_fn('@local.scope', 'locals'), { desc = "Select language scope" })
    end
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true
        },
        aliases = {
          ["xsd"] = "xml",
        }
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufEnter',
    opts = {
      multiline_threshold = 10,
    },
    keys = {
      { ",TC", ":TSContext toggle<CR>", desc = "toggle treesitter context" },
    }
  }
}
