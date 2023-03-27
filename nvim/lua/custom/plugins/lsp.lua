--  ╭──────────────────────────────────────────────────────────╮
--  │   LSP Configuration & Plugins                            │
--  ╰──────────────────────────────────────────────────────────╯

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Useful status updates for LSP
    -- Standalone UI for nvim-lsp progress
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    {
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup({
          sources = {
            ["null-ls"] = {
              ignore = true,
            },
          },
          timer = {
            task_decay = 400,
            fidget_decay = 700,
          },
        })
      end,
    },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",

    -- Improve any TypeScript projects
    "jose-elias-alvarez/typescript.nvim",

    -- Autoinstall null-ls formatters
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "lukas-reineke/lsp-format.nvim",
      },
    },

    -- Diagnostics
    {
      "folke/trouble.nvim",
      dependencies = {
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("trouble").setup({
          use_diagnostic_signs = true,
        })

        vim.keymap.set(
          "n",
          "<leader>xx",
          "<cmd>TroubleToggle<cr>",
          { silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>xw",
          "<cmd>TroubleToggle workspace_diagnostics<cr>",
          { silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>xd",
          "<cmd>TroubleToggle document_diagnostics<cr>",
          { silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>xl",
          "<cmd>TroubleToggle loclist<cr>",
          { silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>xq",
          "<cmd>TroubleToggle quickfix<cr>",
          { silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "gR",
          "<cmd>TroubleToggle lsp_references<cr>",
          { silent = true, noremap = true }
        )

        -- More keybinds
        vim.keymap.set(
          "n",
          "gk",
          vim.diagnostic.goto_prev,
          { desc = "Go to previous diagnostic message" }
        )
        vim.keymap.set(
          "n",
          "gj",
          vim.diagnostic.goto_next,
          { desc = "Go to next diagnostic message" }
        )
        vim.keymap.set(
          "n",
          "<leader>e",
          vim.diagnostic.open_float,
          { desc = "Open floating diagnostic message" }
        )
        vim.keymap.set(
          "n",
          "<leader>q",
          vim.diagnostic.setloclist,
          { desc = "Open diagnostics list" }
        )
      end,
    },
  },
  config = function()
    local lsp_format = require("lsp-format")
    lsp_format.setup()

    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      lsp_format.on_attach(client)

      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>li", ":LspInfo<CR>", "[I]nfo")
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
      nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
      nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap(
        "<leader>ws",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        "[W]orkspace [S]ymbols"
      )

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      -- TODO: find another key
      -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
    end

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. They will be passed to
    --  the `settings` field of the server config. You must look up that documentation yourself.
    local servers = {
      bashls = {},
      jsonls = {
        json = {
          schemas = {
            {
              description = "TypeScript compiler configuration file",
              fileMatch = { "tsconfig.json", "tsconfig.*.json" },
              url = "http://json.schemastore.org/tsconfig",
            },
            {
              description = "Babel configuration",
              fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
              url = "http://json.schemastore.org/lerna",
            },
            {
              description = "ESLint config",
              fileMatch = { ".eslintrc.json", ".eslintrc" },
              url = "http://json.schemastore.org/eslintrc",
            },
            {
              description = "Prettier config",
              fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
              url = "http://json.schemastore.org/prettierrc",
            },
            {
              description = "Vercel Now config",
              fileMatch = { "now.json" },
              url = "http://json.schemastore.org/now",
            },
            {
              description = "Stylelint config",
              fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
              url = "http://json.schemastore.org/stylelintrc",
            },
          },
        },
      },
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
      rust_analyzer = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true,
          },
        },
      },
      sorbet = {},
      tsserver = {},
      yamlls = {
        yaml = {
          schemas = {
            -- Github actions
            ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
            ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
          },
        },
      },
    }

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require("mason").setup()

    -- Ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    local lspconfig = require("lspconfig")

    mason_lspconfig.setup_handlers({
      -- Default setup handler
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        })
      end,
      -- Custom handlers
      sorbet = function()
        lspconfig.sorbet.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {},
          root_dir = lspconfig.util.root_pattern("sorbet"),
        })
      end,
      tsserver = function()
        lspconfig.tsserver.setup({
          cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
          filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
          init_options = {
            maxTsServerMemory = "8192",
            preferences = {
              -- Ensure we always import from absolute paths
              importModuleSpecifierPreference = "non-relative",
            },
          },
          root_dir = lspconfig.util.root_pattern("tsconfig.json"),
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            if client.config.flags then
              client.config.flags.allow_incremental_sync = true
            end

            on_attach(client, bufnr)
          end,
        })
      end,
    })

    local ignorePrettierRules = function(diagnostic)
      return diagnostic.code ~= "prettier/prettier"
    end

    local hasEslintConfig = function(utils)
      return utils.root_has_file({
        ".eslintrc",
        ".eslintrc.json",
        ".eslintrc.js",
      })
    end

    local hasPrettierConfig = function(utils)
      return utils.root_has_file({
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.toml",
        ".prettierrc.yml",
        ".prettierrc.yaml",
      })
    end

    local eslintConfig = {
      condition = hasEslintConfig,
      filter = ignorePrettierRules,
    }

    local null_ls = require("null-ls")
    local rubyfmt_formatter = require("custom.rubyfmt")

    null_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      sources = {
        --  ╭──────────────────────────────────────────────────────────╮
        --  │     Lua                                                  │
        --  ╰──────────────────────────────────────────────────────────╯
        null_ls.builtins.formatting.stylua,

        --  ╭──────────────────────────────────────────────────────────╮
        --  │     Ruby                                                 │
        --  ╰──────────────────────────────────────────────────────────╯
        rubyfmt_formatter,

        --  ╭──────────────────────────────────────────────────────────╮
        --  │     TypeScript                                           │
        --  ╰──────────────────────────────────────────────────────────╯
        null_ls.builtins.formatting.prettierd.with({
          condition = hasPrettierConfig,
          env = {
            -- Always use the local prettier in node_modules, especially when prettier is pointing
            -- at a feature branch or something weird.
            -- PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
          },
        }),

        null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
        null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
      },
    })

    require("mason-null-ls").setup({
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    })
  end,
}
