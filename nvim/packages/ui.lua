return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        spec = {
          { "<leader>b", group = "+comment-box" },
          { "<leader>l", group = "+lsp" },
          { "<leader>m", group = "+marks" },
          { "<leader>n", group = "+a[n]notations" },
          { "<leader>s", group = "+search" },
          { "<leader>x", group = "+trouble" },
        },
      })
    end,
  },

  -- color scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavor = "mocha",
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- disable highlights automatically on cursor move
  "romainl/vim-cool",

  -- show hex colors in CSS/HTML files
  {
    "NvChad/nvim-colorizer.lua",
    opts = {},
  },

  -- better window dressing
  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "drzel/vim-line-no-indicator",
    },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = "catppuccin",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "filename", "diff", "diagnostics" },
        lualine_x = { "filesize", "encoding", "fileformat", "filetype" },
        lualine_y = {},
        lualine_z = {
          function()
            return vim.fn.LineNoIndicator()
          end,
        },
      },
    },
  },
}
