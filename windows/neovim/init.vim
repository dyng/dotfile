" Platform-specific providers and shell
" No configured plugin uses Neovim's remote-plugin providers. Python and Node
" executables are still available to LSP, DAP, tests, and Markdown Preview.
let g:loaded_python3_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

if has('win32')
    let $JAVA_HOME = expand('~/scoop/apps/temurin21-jdk/current')
    let s:windows_tool_paths = [
        \ expand('~/scoop/shims'),
        \ expand('~/scoop/apps/nodejs-lts/current'),
        \ expand('~/scoop/apps/nodejs-lts/current/bin'),
        \ expand('~/scoop/apps/mingw/current/bin'),
        \ $JAVA_HOME . '/bin',
        \ ]
    let $PATH = join(s:windows_tool_paths, ';') . ';' . $PATH
    let $CC = expand('~/scoop/apps/mingw/current/bin/gcc.exe')
    let $CXX = expand('~/scoop/apps/mingw/current/bin/g++.exe')

    " Keep short-lived external commands on Windows' lightweight native shell.
    let &shell = 'cmd.exe'
    let &shellcmdflag = '/s /c'
    let &shellredir = '>%s 2>&1'
    let &shellpipe = '2>&1| tee'
    let &shellquote = ''
    let &shellxquote = '"'
endif

" Required by UI plugins such as nvim-colorizer on modern terminals/Neovide.
set termguicolors

" set mapleader
let mapleader = ","
" }}}

" Load Plugins {{{
lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), "\n"))
local lazy_lock = assert(lock["lazy.nvim"], "lazy.nvim is missing from lazy-lock.json")

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_echo({{ "Installing lazy.nvim...", "WarningMsg" }}, true, {})
  local clone_output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. clone_output)
  end
  vim.api.nvim_echo({{ "Installing lazy.nvim complete", "WarningMsg" }}, true, {})
end

-- lazy.nvim must be restored before it reads the lockfile. Otherwise a newer
-- manager checkout can rewrite its own lock entry during startup.
local lazy_head = vim.trim(vim.fn.system({ "git", "-C", lazypath, "rev-parse", "HEAD" }))
if vim.v.shell_error ~= 0 then
  error("Failed to read lazy.nvim revision:\n" .. lazy_head)
end
if lazy_head ~= lazy_lock.commit then
  local checkout_output = vim.fn.system({
    "git", "-C", lazypath, "checkout", lazy_lock.commit,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to restore locked lazy.nvim commit:\n" .. checkout_output)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- neo-tree.nvim
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = { "Neotree" },
        keys = {
            { "gn", "<cmd>Neotree reveal<cr>", mode = "n" },
            { "gN", "<cmd>Neotree dir=.<cr>", mode = "n" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
          close_if_last_window = true,
          enable_diagnostics = false,
          window = {
            width = 30,
            mappings = {
              ["<space>"] = "none",
              ["e"] = "toggle_node",
            },
          },
          filesystem = {
            group_empty_dirs = true,
            use_libuv_file_watcher = true,
            follow_current_file = {
              enabled = true,
            },
          },
        },
    },

    -- noice.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
          },
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
          },
        },
        dependencies = {
          "MunifTanjim/nui.nvim",
          "rcarriga/nvim-notify",
        },
    },

    -- telescope.nvim
    {
      "nvim-telescope/telescope.nvim",
      cmd = { "Telescope" },
      keys = {
        {
          "<C-P>",
          function()
            require("telescope.builtin").find_files({ cwd = vim.fn.ProjectRoot() })
          end,
          mode = "n",
        },
        { "gp", function() require("telescope.builtin").find_files() end, mode = "n" },
        { "gm", function() require("telescope.builtin").oldfiles() end, mode = "n" },
        { "gb", function() require("telescope.builtin").lsp_document_symbols() end, mode = "n" },
        { "gB", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, mode = "n" },
      },
      dependencies = {
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      opts = {
        defaults = {
          path_display = { 'filename_first' },
          mappings = {
            i = {
              ["<esc>"] = function(...)
                return require('telescope.actions').close(...)
              end,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      },
      config = function(_, opts)
        local telescope = require('telescope')
        telescope.setup(opts)
        telescope.load_extension('fzf')
      end,
    },

    -- nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate"
    },

    -- mason.nvim
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
        opts = {
          log_level = vim.log.levels.DEBUG,
        },
    },

    -- nvim-lspconfig
    {
      "neovim/nvim-lspconfig",
      ft = {
        "c",
        "cpp",
        "go",
        "python",
        "rust",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "sh",
        "bash",
        "ps1",
      },
      dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
      },
      config = function()
        vim.lsp.config("clangd", {
          cmd = { "clangd", "--offset-encoding=utf-16" },
        })

        vim.lsp.config("pyright", {
          settings = {
            python = {
              analysis = {
                exclude = {
                  "**/venv",
                  "**/__pycache__",
                  "**/site-packages",
                  "**/dist-packages",
                },
                diagnosticMode = "openFilesOnly",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        })

        vim.lsp.config("gopls", {
          settings = {
            gopls = {
              env = {
                -- GOPACKAGESDRIVER can be set here when needed.
              },
            },
          },
        })

        require("mason-lspconfig").setup({
          ensure_installed = {
            "clangd",
            "pyright",
            "gopls",
            "rust_analyzer",
            "ts_ls",
            "bashls",
            "powershell_es",
          },
          automatic_enable = {
            exclude = { "jdtls", "rust_analyzer" },
          },
        })
      end,
    },

    {
      "nvim-java/nvim-java",
      ft = { "java" },
      dependencies = {
        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim",
      },
      opts = {
        jdtls = {
          -- Keep JDTLS aligned with nvim-java's Java test/debug extensions.
          auto_install = true,
        },
        spring_boot_tools = {
          enable = false,
        },
        jdk = {
          auto_install = false,
          -- JDTLS itself requires Java 21, even when the project targets Java 8.
          path = vim.fn.expand("~/scoop/apps/temurin21-jdk/current"),
        },
      },
      config = function(_, opts)
        require("java").setup(opts)
        vim.lsp.config("jdtls", {
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-1.8",
                    path = vim.fn.expand("~/scoop/apps/temurin8-jdk/current"),
                    default = true,
                  },
                  {
                    name = "JavaSE-21",
                    path = vim.fn.expand("~/scoop/apps/temurin21-jdk/current"),
                  },
                },
              },
            },
          },
        })
        vim.lsp.enable("jdtls")
      end,
    },

    {
      "mrcjkb/rustaceanvim",
      ft = { "rust" },
    },

    -- nvim-cmp
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        {
          "hrsh7th/vim-vsnip",
          dependencies = {
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "rafamadriz/friendly-snippets",
          }
        },
      },
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          preselect = cmp.PreselectMode.Item,
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          matching = {
            disallow_fuzzy_matching = false,
          },
          mapping = {
            ['<TAB>'] = cmp.mapping.select_next_item(),
            ['<Down>'] = cmp.mapping.select_next_item(),
            ['<S-TAB>'] = cmp.mapping.select_prev_item(),
            ['<Up>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<C-c>'] = cmp.mapping.abort(),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'vsnip' },
          }, {
            { name = 'buffer' },
          },
        })

        cmp.setup({
          enabled = function()
            return vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'prompt'
              or (package.loaded['cmp_dap'] and require('cmp_dap').is_dap_buffer())
          end,
        })
        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
          sources = {
            { name = "dap" },
          },
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' },
          }, {
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!', '%', 'write', 'wall', 'quit', 'qall', 'xit' },
              },
            },
          }),
        })
      end,
    },

    -- nvim-dap
    {
        "mfussenegger/nvim-dap",
        cmd = { "DapListBreakpoints", "DapClearBreakpoints", "DapUIToggle" },
        keys = {
          { "guu", function() require('dap').run_last() end, mode = "n" },
          { "guj", function() require('dap').continue() end, mode = "n" },
          { "gub", function() require('dap').toggle_breakpoint() end, mode = "n" },
          {
            "guB",
            function()
              local condition = vim.fn.input('Condition: ')
              require('dap').toggle_breakpoint(condition)
            end,
            mode = "n",
          },
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "rcarriga/cmp-dap",
            "jay-babu/mason-nvim-dap.nvim",

            -- language specific plugins
            {
              "leoluz/nvim-dap-go",
              ft = { "go" },
              opts = {},
            },
        },
        config = function()
          local dap = require('dap')

          local function set_dap_keymap(mode, key, fn)
            local function if_dap_running(callback, fallback_key)
              local rhs = vim.fn.maparg(fallback_key, 'n')
              if rhs ~= '' and not rhs:find('^<') then
                fallback_key = rhs
              end
              if fallback_key:find('^<') then
                fallback_key = "\\" .. fallback_key
              end
              return function()
                local session = dap.session()
                if session and session.filetype == vim.bo.filetype then
                  callback()
                else
                  vim.cmd('execute "normal! ' .. fallback_key .. '"')
                end
              end
            end
            vim.keymap.set(mode, key, if_dap_running(fn, key), { noremap = true, silent = true })
          end

          vim.keymap.set('n', 'guu', dap.run_last, { silent = true })
          vim.keymap.set('n', 'guj', dap.continue, { silent = true })
          vim.keymap.set('n', 'gub', dap.toggle_breakpoint, { silent = true })
          vim.keymap.set('n', 'guB', function()
            local condition = vim.fn.input('Condition: ')
            dap.toggle_breakpoint(condition)
          end, { silent = true })
          set_dap_keymap('n', '<up>', dap.step_back)
          set_dap_keymap('n', '<down>', dap.step_over)
          set_dap_keymap('n', '<right>', dap.step_into)
          set_dap_keymap('n', '<left>', dap.step_out)
          set_dap_keymap('n', 'J', dap.continue)
          set_dap_keymap('n', 'C', dap.run_to_cursor)
          set_dap_keymap('n', '<C-c>', dap.terminate)

          vim.api.nvim_create_user_command('DapListBreakpoints', function()
            dap.list_breakpoints()
            vim.cmd('copen')
          end, {})
          vim.api.nvim_create_user_command('DapClearBreakpoints', dap.clear_breakpoints, {})

          vim.api.nvim_set_hl(0, 'NvimDapBreakpoint', { fg = '#e06c75' })
          vim.api.nvim_set_hl(0, 'NvimDapBreakpointRejected', { fg = '#5c6370' })
          vim.api.nvim_set_hl(0, 'NvimDapStopped', { fg = '#7ac836' })
          vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'NvimDapBreakpoint' })
          vim.fn.sign_define('DapBreakpointRejected', { text = '●', texthl = 'NvimDapBreakpointRejected' })
          vim.fn.sign_define('DapBreakpointCondition', { text = '◐', texthl = 'NvimDapBreakpoint' })
          vim.fn.sign_define('DapStopped', { text = '⮕', texthl = 'NvimDapStopped' })

          require('mason-nvim-dap').setup({
            handlers = {
              function(config)
                require('mason-nvim-dap').default_setup(config)
              end,
              python = function(config)
                config.adapters = {
                  type = "executable",
                  command = vim.fn.exepath("python"),
                  args = { "-m", "debugpy.adapter" },
                }
                table.insert(config.configurations, {
                  type = "python",
                  request = "launch",
                  name = "Python: Launch",
                  program = "${file}",
                  console = 'integratedTerminal',
                  env = { PYTHONPATH = "${workspaceFolder}" },
                  cwd = "${workspaceFolder}",
                })
                table.insert(config.configurations, {
                  type = "python",
                  request = "launch",
                  name = "Python: Launch with Arguments",
                  program = "${file}",
                  console = 'integratedTerminal',
                  env = { PYTHONPATH = "${workspaceFolder}" },
                  cwd = "${workspaceFolder}",
                  args = function()
                    return vim.split(vim.fn.input("Arguments: "), " ")
                  end,
                })
                require('mason-nvim-dap').default_setup(config)
              end,
            },
          })

          local dapui = require('dapui')
          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = { edit = "m", expand = "e", open = "<cr>" },
            layouts = {
              {
                position = "left",
                size = 40,
                elements = {
                  { id = "stacks", size = 0.4 },
                  { id = "breakpoints", size = 0.3 },
                  { id = "watches", size = 0.3 },
                },
              },
              {
                position = "bottom",
                size = 0.3,
                elements = {
                  { id = "scopes", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
              },
            },
            controls = { enabled = true, element = "console" },
          })
          dap.listeners.after.event_initialized["dapui_config"] = function(session)
            if session.parent == nil then dapui.open() end
          end
          dap.listeners.before.event_terminated["dapui_config"] = function(session)
            if session.parent == nil then dapui.close() end
          end
          vim.api.nvim_create_user_command('DapUIToggle', dapui.toggle, {})
          set_dap_keymap({ 'n', 'v' }, 'M', dapui.eval)
          set_dap_keymap({ 'n', 'v' }, 'R', function() dapui.float_element('repl') end)
        end,
    },

    -- none-ls.nvim
    {
        "nvimtools/none-ls.nvim",
        cmd = { "NullLsInfo", "NullLsLog" },
        keys = {
          {
            "ef",
            function()
              vim.lsp.buf.format({ async = false })
            end,
            mode = { "n", "v" },
          },
        },
        dependencies = {
            "jay-babu/mason-null-ls.nvim",
        },
        config = function()
          require("mason-null-ls").setup({
            ensure_installed = { "black", "prettierd", "stylua" },
            automatic_installation = false,
            handlers = {},
          })
          require("null-ls").setup({ sources = {} })
        end,
    },

    -- lualine.nvim
    "nvim-lualine/lualine.nvim",

    -- nvim-bqf
    {
      "kevinhwang91/nvim-bqf",
      ft = { "qf" },
      opts = {
        auto_enable = true,
        func_map = {
          open = 'o',
          openc = '<cr>',
          prevhist = '<c-h>',
          nexthist = '<c-l>',
          pscrollup = '<c-u>',
          pscrolldown = '<c-d>',
        },
        preview = {
          win_height = 999,
        },
      },
    },

    -- vim-illuminate
    {
      "RRethy/vim-illuminate",
      event = "VeryLazy",
      config = function()
        require('illuminate').configure({
          large_file_cutoff = 3000,
          large_file_overrides = {
            providers = { 'lsp', 'treesitter' },
          },
          filetypes_denylist = { 'NvimTree', 'copilot-chat' },
        })
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'LspReferenceText' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'LspReferenceText' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'LspReferenceText' })
      end,
    },

    -- vim-matchup
    {
      "andymass/vim-matchup",
      event = "BufReadPost",
    },

    -- toggleterm.nvim
    {
      "akinsho/toggleterm.nvim",
      opts = {
        open_mapping = '<A-/>',
        shell = function()
          local pwsh = vim.fn.exepath('pwsh')
          return pwsh ~= '' and (vim.fn.shellescape(pwsh) .. ' -NoLogo') or vim.o.shell
        end,
        direction = 'horizontal',
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.4
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
      },
      cmd = { "ToggleTerm" },
      keys = { "<A-/>", "<cmd>ToggleTerm<cr>" },
    },

    -- neovim-session-manager
    {
      "Shatur/neovim-session-manager",
      keys = {
        { "gM", "<cmd>SessionManager load_session<cr>", mode = "n" },
      },
      cmd = { "SessionManager" },
      config = function()
        require("session_manager").setup({
          autoload_mode = {
              require("session_manager.config").AutoloadMode.CurrentDir,
              require("session_manager.config").AutoloadMode.GitSession
          },
          autosave_ignore_filetypes = { 'gitcommit' },
          autosave_ignore_buftypes = {
            'help',
            'terminal',
          },
          autosave_last_session = true,
          autosave_only_in_session = true,
        })
        vim.api.nvim_create_autocmd({ 'User' }, {
          pattern = "SessionSavePost",
          callback = function()
            require("venv-selector").deactivate()
          end,
        })
      end,
      enabled = (vim.fn.has("nvim-0.10.0") == 1),
    },

    -- dressing.nvim
    {
      "stevearc/dressing.nvim",
      event = "VeryLazy",
      opts = {
        input = { start_in_insert = true }
      },
    },

    -- yanky.nvim
    {
      "gbprod/yanky.nvim",
      opts = {
        ring = {
          storage = "memory",
        },
      },
      keys = {
        { "ey", "<cmd>Telescope yank_history<cr>", mode = "n" },
        { "<c-y>", "<cmd>Telescope yank_history<cr>", mode = "i" },
      },
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function(_, opts)
        require("yanky").setup(opts)
        require("telescope").load_extension("yank_history")
      end,
    },

    -- vim-auto-save
    "dyng/vim-auto-save",

    -- nvim-colorizer.lua
    {
      "NvChad/nvim-colorizer.lua",
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        user_default_options = { mode = "background" }
      },
    },

    -- nvim-lightbulb
    {
      "kosayoda/nvim-lightbulb",
      event = "LspAttach",
      opts = {
        sign = {
          enabled = false,
        },
        virtual_text = {
          enabled = true,
        },
        autocmd = {
          enabled = true
        },
        ignore = {
          actions_without_kind = true,
        }
      },
    },

    -- nvim-early-retirement
    {
      "chrisgrieser/nvim-early-retirement",
      event = "VeryLazy",
      opts = {
        retirementAgeMins = 20,
        minimumBufferNum = 20,
      },
    },

    -- neotest
    {
      "nvim-neotest/neotest",
      keys = {
        { "gto", function() require("neotest").output.open({ enter = true, auto_close = true }) end, mode = "n" },
        { "gtn", function() require("neotest").run.run() end, mode = "n" },
        { "gtf", function() require("neotest").run.run(vim.fn.expand("%")) end, mode = "n" },
        { "gun", function() require("neotest").run.run({ strategy = "dap" }) end, mode = "n" },
      },
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        {
          "fredrikaverpil/neotest-golang",
          dependencies = { "leoluz/nvim-dap-go" }
        },
      },
      config = function()
        local neotest = require("neotest")
        neotest.setup({
          adapters = {
            require("neotest-python")({
              dap = { justMyCode = false },
            }),
            require("neotest-golang")({
              go_test_args = { "-v", "-race", "-count=1" },
            }),
          },
        })
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
          virtual_text = {
            format = function(diagnostic)
              return diagnostic.message
                :gsub("\n", " ")
                :gsub("\t", " ")
                :gsub("%s+", " ")
                :gsub("^%s+", "")
            end,
          },
        }, neotest_ns)
      end,
    },

    -- venv-selector.nvim
    {
      "linux-cultist/venv-selector.nvim",
      opts = {
        debug = true,
        enable_cached_venvs = false,
        cached_venv_automatic_activation = false,
        activate_venv_in_terminal = false,
        notify_user_on_venv_activation = true,
      },
      ft = { "python" },
      cmd = { "VenvInfo", "VenvDeactivate", "VenvSelect", "VenvSelectCached" },
      config = function(_, opts)
        local venv = require("venv-selector")
        venv.setup(opts)
        vim.api.nvim_create_user_command("VenvInfo", venv.venv, {})
        vim.api.nvim_create_user_command("VenvDeactivate", venv.deactivate, {})
      end,
    },

    -- aerial.nvim
    {
      'stevearc/aerial.nvim',
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons"
      },
      opts = {
        nav = {
          preview = false,
          keymaps = {
            ["<Left>"] = "actions.left",
            ["<Right>"] = "actions.right",
            ["<Esc>"] = "actions.close",
            ["q"] = "actions.close",
          },
        },
      },
      keys = {
        { "ga", "<cmd>AerialNavOpen<cr>" },
        { "gA", "<cmd>AerialToggle!<cr>" },
      },
    },

    -- nvim-treesitter-context
    {
      "nvim-treesitter/nvim-treesitter-context",
      event = { "BufReadPost", "BufNewFile" },
      opts = {
        multiline_threshold = 1,
      },
    },

    -- diffview.nvim
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewFileHistory" },
      opts = {
        keymaps = {
          file_history_panel = {
            { "n", "q", ":DiffviewClose<CR>", { desc = "Close the panel" } },
          },
        },
      },
      keys = {
        { "gsh", "<cmd>DiffviewFileHistory<cr>", mode = "n" }
      },
    },

    -- gitsigns.nvim
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {}
    },

    -- Comment.nvim
    {
      "numToStr/Comment.nvim",
      opts = {
        padding = true,
        mappings = {
          basic = false,
          extra = false,
        },
      },
      keys = {
        { "ec", "<Plug>(comment_toggle_linewise_current)",  mode = "n" },
        { "eC", "<Plug>(comment_toggle_blockwise_current)", mode = "n" },
        { "ec", "<Plug>(comment_toggle_linewise_visual)",   mode = "x" },
        { "eC", "<Plug>(comment_toggle_blockwise_visual)",  mode = "x" },
      },
    },

    -- nvim-autopairs
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      opts = {
        check_ts = true,
      }
    },

    -- remote-nvim.nvim
    {
      "amitds1997/remote-nvim.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim",
      },
      opts = {
        log = { level = "debug" },
      },
      cmd = { "RemoteStart", "RemoteInfo", "RemoteLog" },
    },

    -- nvim-osc52
    {
      "ojroques/nvim-osc52",
      enabled = (vim.fn.has("nvim-0.10.0") == 0),
      init = function()
        local function copy(lines, _)
          require('osc52').copy(table.concat(lines, '\n'))
        end

        local function paste()
          return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
        end

        vim.g.clipboard = {
          name = 'osc52',
          copy = { ['+'] = copy, ['*'] = copy },
          paste = { ['+'] = paste, ['*'] = paste },
        }
      end,
    },

    -- bookmarks.nvim
    {
      "LintaoAmons/bookmarks.nvim",
      tag = "v1.4.2",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "stevearc/dressing.nvim",
      },
      opts = {
        signs = {
          mark = { icon = "", color = "red", line_bg = "#572626" },
        },
      },
      keys = {
        { "ma", "<cmd>BookmarksMark<cr>", mode = "n" },
        { "mL", "<cmd>BookmarksGoto<cr>", mode = "n" },
      },
    },

    -- fugit2.nvim
    {
      'SuperBo/fugit2.nvim',
      init = function()
        -- fugit2 main currently loads this module from its former core path.
        package.preload['fugit2.core.pendulum'] = function()
          return require('fugit2.util.pendulum')
        end
      end,
      dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'nvim-lua/plenary.nvim',
      },
      opts = {
        libgit2_path = vim.fn.has("win32") == 1
          and (vim.fn.stdpath("data") .. "/libgit2/bin/libgit2.dll")
          or "/opt/homebrew/lib/libgit2.dylib",
        width = 100,
      },
      config = function(_, opts)
        require('fugit2').setup(opts)

        -- libgit2 returns workdir paths with forward slashes on Windows, while
        -- Neovim buffer names use backslashes. Fugit2's relative-path logic
        -- compares them as strings and otherwise passes an absolute path to Git.
        if vim.fn.has('win32') == 1 then
          local function patch_blame_path(module_name)
            local blame_view = require(module_name)
            local original_init = blame_view.init

            blame_view.init = function(self, namespace, repo, file_bufnr)
              original_init(self, namespace, repo, file_bufnr)

              local workdir = repo:workdir()
              if not workdir then
                return
              end

              local relative_path = vim.fs.relpath(
                vim.fs.normalize(workdir),
                vim.fs.normalize(vim.api.nvim_buf_get_name(file_bufnr))
              )
              if relative_path then
                self._git.file_path = relative_path:gsub('\\', '/')
              end
            end
          end

          patch_blame_path('fugit2.view.git_blame_file')
          patch_blame_path('fugit2.view.git_blame')
        end
      end,
      cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
      keys = {
        { 'gsb', '<cmd>Fugit2Blame<cr>', mode = 'n' },
      },
    },

    --
    {
      "jbyuki/one-small-step-for-vimkind",
      cmd = { "OSVLaunch", "OSVRunThis", "OSVStop" },
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        local dap = require"dap"
          dap.configurations.lua = {
            {
              type = 'nlua',
              request = 'attach',
              name = "Attach to running Neovim instance",
            }
          }

          dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
          end
      end
    },

    -- old vim plugins
    "dyng/auto_mkdir",
    "easymotion/vim-easymotion",
    "mbbill/undotree",
    "machakann/vim-sandwich",
    "junegunn/vim-easy-align",
    "dyng/ctrlsf.vim",
    "mg979/vim-visual-multi",
    {
      "inkarkat/vim-mark",
      dependencies = {
        "inkarkat/vim-ingo-library",
      }
    },
    "AndrewRadev/linediff.vim",
    "vim-scripts/ReloadScript",
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = "cd app && npx --yes yarn install --frozen-lockfile",
    },

    -- Language Specific Plugins
    "dyng/dejava.vim",

    -- Colorschemes
    { "tomasr/molokai", lazy = true },
    { "marko-cerovac/material.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = false, priority = 1000 },
    { "projekt0n/github-nvim-theme", lazy = true },

    -- Documents
    "yianwillis/vimcdoc",
}

local lazy_profile = vim.env.NVIM_LAZY_PROFILE == "1"
require("lazy").setup(plugins, {
  rocks = { enabled = false },
  profiling = {
    loader = lazy_profile,
    require = lazy_profile,
  },
})
EOF
" }}}

" Basic Config {{{
" Encoding & Language {{{
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,sjis,cp936,gb18030,big5,euc-jp,euc-kr,latin1
silent! language en_US.UTF-8
" }}}

" Spelling Check {{{
" default setting
set nospell

function! s:SetSpellingCheck(lang)
    setl spell
    exec "setl spelllang=" . a:lang
endfunction

augroup spelling
    autocmd!
    autocmd FileType text,markdown call s:SetSpellingCheck("en_us")
augroup END
" }}}

" Indentation {{{
set magic
set ruler
set autoindent
set shiftwidth=4
set tabstop=8
set smarttab
set expandtab
set display=lastline
" }}}

" Search {{{
set incsearch
set ignorecase
set smartcase
" }}}

" UI {{{
set backspace=indent,eol,start
if exists('+guioptions')
    set guioptions=
endif
set hlsearch
set showmatch
set laststatus=2

set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
autocmd FileType git*,help setlocal nolist

" Colorscheme
if exists('+t_Co')
    set t_Co=256
endif
set background=dark

colorscheme onedark

" Font
if exists('g:neovide')
    set guifont=JetBrainsMono\ Nerd\ Font:h12
    let g:neovide_cursor_animation_length = 0
    let g:neovide_cursor_trail_size = 0
elseif has('gui_macvim')
    set guifont=Inconsolata\ Nerd\ Font\ Mono:h16
elseif exists("g:gui_vimr")
    set guifont=BlexMono\ Nerd\ Font\ Mono:h14
endif

" signs
lua << EOF
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
EOF
" }}}

" Syntax {{{
syntax on
filetype plugin indent on
set modeline                 "modeline is by default disabled on Debian
set completeopt=menu,menuone,noselect
set wildmenu
" }}}

" Terminal {{{
tnoremap <A-q> <C-\><C-n>
tnoremap <silent> <A-h> <C-\><C-N><C-w>h
tnoremap <silent> <A-j> <C-\><C-N><C-w>j
tnoremap <silent> <A-k> <C-\><C-N><C-w>k
tnoremap <silent> <A-l> <C-\><C-N><C-w>l
inoremap <silent> <A-h> <C-\><C-N><C-w>h
inoremap <silent> <A-j> <C-\><C-N><C-w>j
inoremap <silent> <A-k> <C-\><C-N><C-w>k
inoremap <silent> <A-l> <C-\><C-N><C-w>l
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l
" }}}

" Maps {{{
" Move line start and end
noremap H ^
noremap L $
inoremap <Home> <C-O>g^
inoremap <End>  <C-O>g$
" Quick paging
nnoremap <Space> <C-D>
vnoremap <Space> <C-D>
" Copy to line end
nnoremap Y y$
" Cursor move
nnoremap <Down> gj
nnoremap <Up>   gk
inoremap <Down> <C-O>gj
inoremap <Up>   <C-O>gk

" quickfix
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> Q :call ToggleQuickFix()<cr>
autocmd FileType qf nnoremap <buffer><silent> q :quit<cr>

" Tab navigation
nnoremap <silent> <C-Tab> :tabnext<CR>

" Window switch
nnoremap <silent> <C-H> :wincmd h<CR>
nnoremap <silent> <C-J> :wincmd j<CR>
nnoremap <silent> <C-K> :wincmd k<CR>
nnoremap <silent> <C-L> :wincmd l<CR>
" Focus new splited window
nnoremap <silent> <C-W>s :wincmd s\|wincmd j<CR>
nnoremap <silent> <C-W>v :wincmd v\|wincmd l<CR>

" Window resize
nnoremap <silent> <C-Up> <cmd>call <SID>ResponsiveResize('up')<cr>
nnoremap <silent> <C-Down> <cmd>call <SID>ResponsiveResize('down')<cr>
nnoremap <silent> <C-Left> <cmd>call <SID>ResponsiveResize('left')<cr>
nnoremap <silent> <C-Right> <cmd>call <SID>ResponsiveResize('right')<cr>

function s:ResponsiveResize(key) abort
    let [leftmost, topmost, rightmost, bottommost] = s:WinRelpos(winnr())
    if a:key == 'up' || a:key == 'down'
        " assume window is topmost unless bottommost
        if bottommost
            if a:key == 'up'
                resize +3
            else
                resize -3
            endif
        else
            if a:key == 'up'
                resize -3
            else
                resize +3
            endif
        endif
    else
        " assume window is leftmost unless rightmost
        if rightmost
            if a:key == 'left'
                vertical resize +3
            else
                vertical resize -3
            endif
        else
            if a:key == 'left'
                vertical resize -3
            else
                vertical resize +3
            endif
        endif
    endif
endfunction

function! s:WinRelpos(winnr) abort
    let height = &lines
    let width = &columns

    let [row, col] = win_screenpos(a:winnr)
    let win_width = winwidth(a:winnr)
    let win_height = winheight(a:winnr)

    let leftmost = (col <= 1)
    let topmost = (row <= 1)
    let rightmost = (col + win_width + 1 >= width)
    let bottommost = (row + win_height + 1 >= height)

    return [leftmost, topmost, rightmost, bottommost]
endfunction

" Nohlsearch
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>
" n always look forward && N always look backward
nnoremap <expr> n v:searchforward ? "n" : "N"
nnoremap <expr> N v:searchforward ? "N" : "n"

" Shift lines leftwards or rightwards
vnoremap <expr> > v:count ? ">" : ">gv"
vnoremap <expr> < v:count ? "<" : "<gv"

" copy&paste keys
" mac
vnoremap <D-c> "+y
nnoremap <D-v> "+p
inoremap <D-v> <C-R>+
cnoremap <D-v> <C-R>+
tnoremap <D-v> <C-\><C-N>"+pI
" windows
vnoremap <C-C> "+y
nnoremap <C-Q> "+p
inoremap <C-V> <C-R>+
cnoremap <C-V> <C-R>+
" Copy filename
nnoremap <silent> yf :let @+ = expand('%')<CR>
nnoremap <silent> yF :let @+ = expand('%:p')<CR>
" Run current line
nnoremap <silent> yr :exec getline('.') \| echo 'executed!'<CR>
vnoremap <silent> Yr :source \| redraw \| echo 'executed!'<CR>
" Shell-style shortcut in command mode
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>

" Auto unfolding
nnoremap n nzv
nnoremap N Nzv

" Correct spell
cab Q q
cab Qa qa
cab W w
cab Wq wq
cab Wa wa
cab X x
" }}}

" Misc {{{
" split window at right side
set splitright

" increase updatetime
set updatetime=100

" disable beeping
set vb
if exists('+t_vb')
    set t_vb=
endif

" add keyword '-'
augroup filetyeSpecKeyword
    au!
    au FileType help setl iskeyword+=-
    au FileType vim setl iskeyword+=# iskeyword+=:
augroup END

" persistent undo
if has("persistent_undo")
    exec "set undodir=" . stdpath('data') . "/undodir"
endif

" language of help doc
set helplang=cn
" }}}
" }}}

" Custom Functions {{{
" VisualSelection {{{
function! VisualSelection()
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ''
    endif
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
" }}}

" ProjectRoot {{{
let s:rootmarkers = ['.git', '.svn', '.hg']

function ProjectRoot() abort
    let name = expand('%:p')
    return s:find_root(name, s:rootmarkers, 0)
endfunction

function s:find_root(name, markers, strict) abort
    let name = fnamemodify((a:name != '')? a:name : bufname('%'), ':p')
    let finding = ''
    " iterate all markers
    for marker in a:markers
        if marker != ''
            " search as a file
            let x = findfile(marker, name . '/;')
            let x = (x == '')? '' : fnamemodify(x, ':p:h')
            " search as a directory
            let y = finddir(marker, name . '/;')
            let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
            " which one is the nearest directory ?
            let z = (strchars(x) > strchars(y))? x : y
            " keep the nearest one in finding
            let finding = (strchars(z) > strchars(finding))? z : finding
        endif
    endfor
    if finding == ''
        let path = (a:strict == 0)? fnamemodify(name, ':h') : ''
    else
        let path = fnamemodify(finding, ':p')
    endif
    if has('win32') || has('win16') || has('win64') || has('win95')
        let path = substitute(path, '\/', '\', 'g')
    endif
    if path =~ '[\/\\]$'
        let path = fnamemodify(path, ':h')
    endif
    return path
endfunction
" }}}

" EscapeFilename {{{
function EscapeFilename(fname) abort
    return substitute(substitute(a:fname, "[\\/]", "%2F", "g"), " ", "%20", "g")
endfunction
" }}}

" BufWipeout {{{
" Wipe all deleted (unloaded & unlisted) or all unloaded buffers
function! BufWipeout(listed) abort
    let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded && (!v.listed || a:listed)})
    if !empty(l:buffers)
        execute 'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
    endif
endfunction
command! -bar -bang BufWipeout call BufWipeout(<bang>0)
" }}}

" SynStack {{{
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}

" }}}

" Custom FileType Config {{{
" golang
autocmd FileType go setlocal tabstop=4 shiftwidth=4 nolist noexpandtab

" lua
autocmd FileType lua setlocal shiftwidth=2

" Java uses the process-local JDK configured at startup on Windows.
if !has('win32')
    autocmd FileType java let $JAVA_HOME = '/usr/local/var/jenv/versions/19'
endif
"}}}

" Inline Plugins {{{
" LastInsert {{{
nnoremap <silent> <C-'> <cmd>call <SID>LastInsertJump()<cr>
augroup lastinsert
    autocmd!
    autocmd InsertLeave * call s:LastInsertSave()
augroup END

let s:LI_PosHist = []
let s:LI_Idx = 0

function s:LastInsertSave() abort
    let pos = getpos('.')
    let pos[0] = bufnr()
    call insert(s:LI_PosHist, pos)
    if len(s:LI_PosHist) > 3
        call remove(s:LI_PosHist, -1)
    endif
endfunction

function s:LastInsertJump() abort
    if len(s:LI_PosHist) == 0
        return
    endif
    let pos = s:LI_PosHist[s:LI_Idx]
    exec 'buffer ' . pos[0]
    call setpos('.', pos)
    let s:LI_Idx = (s:LI_Idx + 1) % len(s:LI_PosHist)
endfunction
" }}}

" vim-rsi {{{
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>

inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap        <C-B> <Left>

inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
" }}}
" }}}

" Plugin Configs {{{
" vim-vsnip {{{
imap <expr> <C-o> vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-o>'
smap <expr> <C-o> vsnip#expandable() ? '<Plug>(vsnip-expand)'    : '<C-o>'
imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
" }}}

" undotree {{{
let g:undotree_SetFocusWhenToggle = 1
nnoremap <silent> <leader>u :UndotreeToggle<CR>
" }}}

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'
let g:EasyMotion_smartcase = 1

nmap f <Plug>(easymotion-s2)
let easymotion_key_map = {
    \ 'zj': '<Plug>(easymotion-j)',
    \ 'zk': '<Plug>(easymotion-k)',
    \ 'zw': '<Plug>(easymotion-w)',
    \ 'zb': '<Plug>(easymotion-b)',
    \ 'zW': '<Plug>(easymotion-W)',
    \ 'zB': '<Plug>(easymotion-B)',
    \ 'ze': '<Plug>(easymotion-e)',
    \ 'zE': '<Plug>(easymotion-E)'
    \ }
for key in keys(easymotion_key_map)
    exec "nmap " . key . " " . easymotion_key_map[key]
    exec "vmap " . key . " " . easymotion_key_map[key]
    exec "omap " . key . " " . easymotion_key_map[key]
endfo
" }}}

" CtrlSF {{{
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
nnoremap <silent> <C-F>o :CtrlSFOpen<CR>
nnoremap <silent> <C-F>j :CtrlSFFocus<CR>
let g:ctrlsf_default_view_mode = 'normal'
let g:ctrlsf_compact_position = 'bottom_outside'
let g:ctrlsf_fold_result = 0
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_toggle_map_key = '\t'
let g:ctrlsf_auto_preview = 1
let g:ctrlsf_extra_backend_args = {
    \ 'pt': '--global-gitignore'
    \ }
let g:ctrlsf_auto_focus = {
    \ 'at': 'start'
    \ }
let g:ctrlsf_extra_root_markers = ['.root']

" ignore trailing space
let g:extra_whitespace_ignored_filetypes = ['ctrlsf']

hi ctrlsfFilename guifg=#ffffff guibg=NONE guisp=NONE gui=bold ctermfg=30 ctermbg=NONE cterm=bold
" }}}

" vim-visual-multi {{{
let g:VM_leader = 'M'
let g:VM_maps = {
    \ 'Skip Region': 'x',
    \ 'Add Cursor Up': 'Mk',
    \ 'Add Cursor Down': 'Mj'
    \}
" }}}

" vim-mark {{{
let g:mw_no_mappings = 1
nmap <silent> mm <Plug>MarkSet
vmap <silent> mm <Plug>MarkSet
nmap <silent> mc <Plug>MarkClear
nmap <silent> mn <Plug>MarkSearchAnyNext
nmap <silent> mN <Plug>MarkSearchAnyPrev
" }}}

" linediff {{{
let g:linediff_buffer_type = 'scratch'
vnoremap zd :Linediff<CR>
autocmd User LinediffBufferReady nnoremap <buffer> q :LinediffReset<CR>
" }}}

" {{{ vim-easy-align
xmap eg <Plug>(EasyAlign)*
nmap eg <Plug>(EasyAlign)*
" }}}

" {{{ vim-sandwich
runtime macros/sandwich/keymap/surround.vim
" }}}

" {{{ lsp-config & mason
lua <<EOF
-- Mappings
local bufopts = { noremap=true, silent=true }
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references { includeDeclaration = false } end, bufopts)
vim.keymap.set('n', 'ge', vim.diagnostic.setloclist, bufopts)
vim.keymap.set('n', 'gE', vim.diagnostic.setqflist, bufopts)
vim.keymap.set('n', 'E', vim.diagnostic.open_float, bufopts)
vim.keymap.set('n', 'ea', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'ern', vim.lsp.buf.rename, bufopts)
EOF
" }}}

" lualine {{{
lua <<EOF
require('lualine').setup({
  sections = {
    lualine_b = {
        'diff',
        'diagnostics',
        {
            function()
                return require("grapple").statusline({ inactive = "" })
            end,
            cond = function()
                return package.loaded["grapple"] and require("grapple").exists()
            end
        },
        {
            function()
                return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
            end,
            padding = { right = 1, left = 1 },
        },
    }
  },
})
EOF
" }}}

" nvim-treesitter {{{
lua << EOF
require('dotfiles.treesitter').setup()
EOF
" }}}

" vim-auto-save {{{
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_write_all_buffers = 1
" }}}

" }}}

" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
