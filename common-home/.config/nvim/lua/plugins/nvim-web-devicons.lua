-- vim:foldmethod=marker
return {
  -- nvim-web-devicons {{{
  {
    -- need a nerd font on the system for this
    -- e.g. `brew install font-hack-nerd-font`
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        color_icons = false,
        default = true,
        strict = true,
        override_by_extension = {
          java = {
            icon = "",
            name = "java"
          }
        }
      }
    end
  },

  --}}}
}
