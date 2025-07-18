-- vim:foldmethod=marker
return {
  -- telescope {{{
  {
    'nvim-lua/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      local telescope_builtin = require('telescope.builtin')
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
          },
          layout_strategy = 'flex',
          path_display = { 'filename_first' },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown({
                layout_config = { width = 0.5, height = 0.4 },
                previewer = false,
              }),
            },
          },
          mappings = {
            n = {
              ['<leader>p'] = {
                require('telescope.actions.layout').toggle_preview,
                type = 'action',
              },
            },
            i = {
              ['<C-o>'] = {
                function()
                  telescope_builtin.resume({ cache_index = 1 })
                end,
                opts = { desc = 'resume last telescope picker' },
              },
            },
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')

      local function is_git_repo()
        vim.fn.system('git rev-parse --is-inside-work-tree')
        return vim.v.shell_error == 0
      end

      local function get_git_root()
        local dot_git_path = vim.fn.finddir('.git', '.;')
        return vim.fn.fnamemodify(dot_git_path, ':h')
      end

      local function maybe_get_git_opts()
        local opts = {}
        if is_git_repo() then
          opts.cwd = get_git_root()
        end
        return opts
      end

      -- this function allows finding all files in a git repo
      -- even if they havent been added
      local function find_files_from_project_git_root()
        local opts = maybe_get_git_opts()
        opts.hidden = true
        opts.follow = true
        telescope_builtin.find_files(opts)
      end

      -- this function will use git ls-files if its a git repo
      -- otherwise fallback to find_files
      local function git_or_find_files()
        local opts = maybe_get_git_opts()
        if is_git_repo() then
          telescope_builtin.git_files(opts)
        else
          telescope_builtin.find_files(opts)
        end
      end

      -- this function will live grep from the git root
      -- if in a git repo
      local function live_grep_from_project_git_root()
        local opts = maybe_get_git_opts()
        telescope_builtin.live_grep(opts)
      end

      local function live_grep_git_root_current_filetype()
        local opts = maybe_get_git_opts()
        opts.type_filter = vim.bo.filetype
        opts.results_title = string.format('Results (%s)', vim.bo.filetype)
        telescope_builtin.live_grep(opts)
      end

      local function grep_string_git_root_current_filetype()
        local opts = maybe_get_git_opts()
        opts.additional_args = { '--type=' .. vim.bo.filetype }
        opts.results_title = string.format('Results (%s)', vim.bo.filetype)
        telescope_builtin.grep_string(opts)
      end

      local function current_buffer_fuzzy_find()
        telescope_builtin.current_buffer_fuzzy_find({
          results_title = vim.fn.expand('%'),
        })
      end

      local function cursor_layout_opts()
        return {
          layout_strategy = 'cursor',
          layout_config = { height = 0.4, width = 180, preview_width = 100, preview_cutoff = 120 },
        }
      end

      -- telescope version has been buggy
      -- nmap('gd', function()
      --   telescope_builtin.lsp_definitions(cursor_layout_opts)
      -- end, 'lsp goto definition (telescope)')
      fr.nmap('gd', vim.lsp.buf.definition, 'go to definition')
      fr.nmap('gi', function()
        telescope_builtin.lsp_implementations(cursor_layout_opts())
      end, 'lsp goto implementation (telescope)')
      fr.nmap('gr', function()
        telescope_builtin.lsp_references(cursor_layout_opts())
      end, 'lsp goto references (telescope)')
      fr.nmap('<space>ltd', function()
        telescope_builtin.lsp_type_definitions(cursor_layout_opts())
      end, 'lsp type definition (telescope)')
      fr.nmap('<space>lvd', function()
        telescope_builtin.lsp_definitions(fr.merge_copy(cursor_layout_opts(), { jump_type = 'vsplit' }))
      end, 'lsp goto definition vsplit (telescope)')
      fr.nmap('<space>lhd', function()
        telescope_builtin.lsp_definitions(fr.merge_copy(cursor_layout_opts(), { jump_type = 'split' }))
      end, 'lsp goto definition hsplit (telescope)')
      fr.nmap('<space>a', find_files_from_project_git_root, 'find files from git root (telescope)')
      -- fr.nmap('<space>f', git_or_find_files, 'git files or find files (telescope)')
      fr.nmap('<space>o', git_or_find_files, 'git files or find files (telescope)')
      fr.nmap('<space>b', function()
        telescope_builtin.buffers({
          show_all_buffers = true,
          sort_mru = true,
          ignore_current_buffer = true,
          results_title = vim.fn.expand('%'),
          preview = {
            hide_on_startup = false,
          },
          attach_mappings = function(_, map)
            map({ 'i', 'n' }, '<C-x>', 'delete_buffer', { desc = 'close selected buffers' })
            map({ 'i', 'n' }, '<C-s>', 'select_horizontal', { desc = 'open selection in a horizontal split' })
            return true
          end,
        })
      end, 'list buffers (telescope)')
      fr.nmap('<space>ss', function()
        telescope_builtin.lsp_document_symbols({ symbol_width = 60 })
      end, 'lsp document symbols - all (telescope)')
      fr.nmap('<space>sv', function()
        telescope_builtin.lsp_document_symbols({
          symbol_width = 60,
          symbols = { 'variable', 'field', 'property', 'constant', 'enummember' },
        })
      end, 'lsp document symbols - variables (telescope)')
      fr.nmap('<space>sf', function()
        telescope_builtin.lsp_document_symbols({
          symbol_width = 60,
          symbols = { 'method', 'function', 'constructor', 'operator' },
        })
      end, 'lsp document symbols - functions (telescope)')
      fr.nmap('<space>sc', function()
        telescope_builtin.lsp_document_symbols({
          symbol_width = 60,
          symbols = { 'class', 'enum', 'interface', 'struct', 'event', 'typeparameter' },
        })
      end, 'lsp document symbols - class (telescope)')
      fr.nmap('<space>sw', telescope_builtin.lsp_dynamic_workspace_symbols, 'lsp dynamic workspace symbols (telescope)')
      fr.nmap('<space>tk', telescope_builtin.keymaps, 'keymaps (telescope)')
      fr.nmap('<space>tt', telescope_builtin.treesitter, 'treesitter (telescope)')
      fr.nmap('<space>tb', telescope_builtin.builtin, 'telescope builtins (telescope)')
      fr.nmap('<space>tr', function()
        telescope_builtin.resume({ cache_index = 1 })
      end, 'telescope resume picker (telescope)')

      fr.nmap('<space>tp', telescope.extensions.persisted.persisted, 'show sessions (telescope)')
      fr.nmap('<space>fb', current_buffer_fuzzy_find, 'live grep current buffer (telescope)')
      fr.map(
        { 'n', 'x' },
        '<space>fw',
        telescope_builtin.grep_string,
        { desc = 'grep string under cursor (telescope)' }
      )
      fr.map(
        { 'n', 'x' },
        '<space>fW',
        grep_string_git_root_current_filetype,
        { desc = 'grep string under cursor with current buffer filetype (telescope)' }
      )
      fr.nmap(
        '<space>fL',
        live_grep_git_root_current_filetype,
        'live grep from git root with current buffer filetype (telescope)'
      )
      fr.nmap('<space>fl', live_grep_from_project_git_root, 'live grep from git root (telescope)')
      fr.nmap('<space>fg', function()
        vim.ui.input({ prompt = 'Enter glob pattern (e.g. *.lua): ' }, function(input)
          if input then
            local opts = maybe_get_git_opts()
            opts.glob_pattern = input
            opts.results_title = string.format('Results (%s)', input)
            telescope_builtin.live_grep(opts)
          end
        end)
      end, 'Live grep with glob filter')
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  -- }}}
}
