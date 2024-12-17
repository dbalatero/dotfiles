-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP                                                     │
-- ╰─────────────────────────────────────────────────────────╯
local config = require("custom.config")

local function get_mason_path()
  if config.stripe.machine then
    return os.getenv("HOME") .. "/stripe/mason"
  else
    return os.getenv("HOME") .. "/.local/share/neovim/mason"
  end
end

return {
  {
    "rafamadriz/friendly-snippets",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local ts_config = {
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          require("packages.lsp.setup").on_attach(client, bufnr)
        end,
        settings = {
          expose_as_code_action = "all",
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          tsserver_max_memory = "auto",
          tsserver_locale = "en",
          -- tsserver_logs = "verbose",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }

      if config.stripe.payServer then
        ts_config.settings.tsserver_path = config.stripe.payServerRootPath
          .. "/frontend/js-scripts/node_modules/typescript/lib/tsserver.js"
      end

      require("typescript-tools").setup(ts_config)
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "ivanjermakov/troublesum.nvim",
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
      vim.keymap.set("n", "gk", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to previous error message" })

      vim.keymap.set(
        "n",
        "g<",
        vim.diagnostic.goto_prev,
        { desc = "Go to previous diagnostic" }
      )

      vim.keymap.set("n", "gj", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = "Go to next error message" })

      vim.keymap.set(
        "n",
        "g>",
        vim.diagnostic.goto_next,
        { desc = "Go to next diagnostic" }
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

      -- temporary
      vim.keymap.set("n", "<leader>lp", function()
        local var_name = vim.fn.expand("<cWORD>")
        if var_name:match("_") ~= nil then
          vim.lsp.buf.rename("_args")
        else
          vim.lsp.buf.rename("args")
        end
      end, { desc = "Rename params -> args" })

      vim.keymap.set("n", "<leader>lm", function()
        vim.lsp.buf.rename("TMutationArgs")
      end, { desc = "Rename mutation" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure servers
      require("packages.lsp.servers")
    end,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
          require("mason").setup({
            install_root_dir = get_mason_path(),
          })
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
          require("mason-tool-installer").setup({
            ensure_installed = {
              -- LSPs
              "bashls",
              "cssls",
              "jsonls",
              "lua_ls",
              "stylua",
              "yamlls",
            },
          })
        end,
      },
      {
        url = "git@git.corp.stripe.com:nms/nvim-lspconfig-stripe.git",
        cond = require("custom.config").stripe.utils.is_stripe_machine,
        config = function()
          require("packages.lsp.payserver_sorbet")
        end,
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        -- progress = {
        --   ignore = {
        --     -- "none-ls",
        --     -- "null-ls",
        --   },
        -- },
      })
    end,
  },
}
