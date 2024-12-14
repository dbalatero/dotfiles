-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP                                                     │
-- ╰─────────────────────────────────────────────────────────╯
local function get_mason_path()
  -- Define the paths
  local stripe_dir = os.getenv("HOME") .. "/stripe"
  local default_path = os.getenv("HOME") .. "/.local/share/neovim/mason"

  -- Check if the stripe directory exists
  local file_exists = vim.fn.isdirectory(stripe_dir) == 1

  -- Return the appropriate path
  if file_exists then
    return stripe_dir .. "/mason"
  else
    return default_path
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
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      debug = true,
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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
        end
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup({
            ensure_installed = {
              "lua_ls",
            },
          })
        end
      }
    },
  }
}
