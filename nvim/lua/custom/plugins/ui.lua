--  ╭──────────────────────────────────────────────────────────╮
--  │   Color schemes and themes                               │
--  ╰──────────────────────────────────────────────────────────╯
return {
  -- disable highlights automatically on cursor move
  "romainl/vim-cool",

  -- color theme
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfly")

      -- Enable transparent terminal background
      vim.o.termguicolors = true
      vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
      ]])
    end,
  },

  -- show hex colors in CSS/HTML files
  {
    "NvChad/nvim-colorizer.lua",
    opts = {},
  },

  { "kyazdani42/nvim-web-devicons", opts = {} },

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
        theme = "nightfly",
        component_separators = "|",
        section_separators = "",
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
