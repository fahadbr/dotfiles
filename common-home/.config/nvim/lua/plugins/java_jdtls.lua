-- vim:foldmethod=marker
-- see lazy plugin spec at
-- https://lazy.folke.io/spec
local function get_raw_config(server)
  local ok, config = pcall(require, 'lspconfig.configs.' .. server)
  if ok then
    return config
  end
  return require('lspconfig.server_configurations.' .. server)
end

local java_filetypes = { 'java' }

return {
  {
    'mfussenegger/nvim-jdtls',
    dependencies = { 'folke/which-key.nvim', 'neovim/nvim-lspconfig' },
    ft = java_filetypes,
    opts = function()
      local cmd = { vim.fn.exepath('jdtls') }
      if fr.module_exists('mason.nvim') then
        local InstallLocation = require("mason-core.installer.InstallLocation")
        local lombok_jar = InstallLocation.global():package('jdtls') .. '/lombok.jar'
        table.insert(cmd, string.format('--jvm-arg=-javaagent:%s', lombok_jar))
      end
      return {
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        root_dir = get_raw_config('jdtls').default_config.root_dir,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/config'
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/workspace'
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              '-configuration',
              opts.jdtls_config_dir(project_name),
              '-data',
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = 'auto', config_overrides = {} },
        -- Can set this to false to disable main class scan, which is a performance killer for large project
        dap_main = {},
        test = true,
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = 'all',
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      -- Find the extra bundles that should be passed on the jdtls command-line
      -- if nvim-dap is enabled with java debug/test.
      local bundles = {} ---@type string[]
      if fr.module_exists('mason.nvim') then
        local mason_registry = require('mason-registry')
        if opts.dap and fr.module_exists('nvim-dap') and mason_registry.is_installed('java-debug-adapter') then
          local java_dbg_path = require("mason-core.installer.InstallLocation").global():package('java-debug-adapter')
          local jar_patterns = {
            java_dbg_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar',
          }
          -- java-test also depends on java-debug-adapter.
          if opts.test and mason_registry.is_installed('java-test') then
            local java_test_path = require("mason-core.installer.InstallLocation").global():package('java-test')
            vim.list_extend(jar_patterns, {
              java_test_path .. '/extension/server/*.jar',
            })
          end
          for _, jar_pattern in ipairs(jar_patterns) do
            for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
              table.insert(bundles, bundle)
            end
          end
        end
      end
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = fr.extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = {
            bundles = bundles,
          },
          settings = opts.settings,
          -- enable CMP capabilities
          capabilities = fr.module_exists('cmp-nvim-lsp') and require('cmp_nvim_lsp').default_capabilities() or nil,
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require('jdtls').start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'jdtls' then
            local wk = require('which-key')
            wk.add({
              {
                mode = 'n',
                buffer = args.buf,
                { '<localleader>jx', group = 'extract' },
                { '<localleader>jxv', require('jdtls').extract_variable_all, desc = 'Extract Variable' },
                { '<localleader>jxc', require('jdtls').extract_constant, desc = 'Extract Constant' },
                { '<localleader>jgs', require('jdtls').super_implementation, desc = 'Goto Super' },
                { '<localleader>jgS', require('jdtls.tests').goto_subjects, desc = 'Goto Subjects' },
                { '<localleader>jo', require('jdtls').organize_imports, desc = 'Organize Imports' },
              },
            })
            wk.add({
              {
                mode = 'v',
                buffer = args.buf,
                { '<localleader>jx', group = 'extract' },
                {
                  '<localleader>jxm',
                  [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                  desc = 'Extract Method',
                },
                {
                  '<localleader>jxv',
                  [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                  desc = 'Extract Variable',
                },
                {
                  '<localleader>jxc',
                  [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                  desc = 'Extract Constant',
                },
              },
            })

            if fr.module_exists('mason.nvim') then
              local mason_registry = require('mason-registry')
              if opts.dap and fr.module_exists('nvim-dap') and mason_registry.is_installed('java-debug-adapter') then
                -- custom init for Java debugger
                require('jdtls').setup_dap(opts.dap)
                if opts.dap_main then
                  require('jdtls.dap').setup_dap_main_class_configs(opts.dap_main)
                end

                -- Java Test require Java debugger to work
                if opts.test and mason_registry.is_installed('java-test') then
                  -- custom keymaps for Java test runner (not yet compatible with neotest)
                  wk.add({
                    {
                      mode = 'n',
                      buffer = args.buf,
                      { '<localleader>t', group = 'test' },
                      {
                        '<localleader>tt',
                        function()
                          require('jdtls.dap').test_class({
                            config_overrides = type(opts.test) ~= 'boolean' and opts.test.config_overrides or nil,
                          })
                        end,
                        desc = 'Run All Test',
                      },
                      {
                        '<localleader>tm',
                        function()
                          require('jdtls.dap').test_nearest_method({
                            config_overrides = type(opts.test) ~= 'boolean' and opts.test.config_overrides or nil,
                          })
                        end,
                        desc = 'Run Nearest Test',
                      },
                      { '<localleader>tT', require('jdtls.dap').pick_test, desc = 'Run Test' },
                    },
                  })
                end
              end
            end

            -- User can set additional keymaps in opts.on_attach
            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end,
      })

      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,
  },
  {
    'mfussenegger/nvim-dap',
    optional = true,
    opts = function()
      -- Simple configuration to attach to remote java debug process
      -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
      local dap = require('dap')
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Debug (Attach) - Remote',
          hostName = '127.0.0.1',
          port = 5005,
        },
      }
    end,
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = { ensure_installed = { 'java-debug-adapter', 'java-test' } },
      },
    },
  },
}
