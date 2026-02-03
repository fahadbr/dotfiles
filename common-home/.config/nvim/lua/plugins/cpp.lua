-- see lazy plugin spec at
-- https://lazy.folke.io/spec
return {
  {
    'p00f/clangd_extensions.nvim',
    url = 'https://git.sr.ht/~p00f/clangd_extensions.nvim',
    lazy = true,
    opts = {
      ast = {
        -- These are unicode, should be available in any font
        role_icons = {
          type = '🄣',
          declaration = '🄓',
          expression = '🄔',
          statement = ';',
          specifier = '🄢',
          ['template argument'] = '🆃',
        },
        kind_icons = {
          Compound = '🄲',
          Recovery = '🅁',
          TranslationUnit = '🅄',
          PackExpansion = '🄿',
          TemplateTypeParm = '🅃',
          TemplateTemplateParm = '🅃',
          TemplateParamObject = '🅃',
        },
        highlights = {
          detail = 'Comment',
        },
      },
      inlay_hints = {
        inline = false,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          root_markers = {
            {
              'Makefile',
              'configure.ac',
              'configure.in',
              'config.h.in',
              'meson.build',
              'meson_options.txt',
              'build.ninja',
            },
            {
              'compile_commands.json',
              'compile_flags.txt',
            },
            '.git',
          },
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          require('clangd_extensions')
          fr.nmap('<localleader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch Source/Header (C/C++)')
          return false
        end,
      },
    },
  },
}
