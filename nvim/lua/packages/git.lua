--  ╭──────────────────────────────────────────────────────────╮
--  │   Git / version control                                  │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "tpope/vim-fugitive",
    config = function()
      -- Every time you open a git object using fugitive it creates a new buffer.
      -- This means that your buffer listing can quickly become swamped with
      -- fugitive buffers. This prevents this from becomming an issue:
      vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        pattern = { "fugitive://*" },
        callback = function()
          vim.cmd([[set bufhidden=delete]])
        end,
      })

      vim.api.nvim_set_keymap(
        "v",
        "<leader>g",
        ":GBrowse!<CR>",
        { noremap = true, desc = "Copy link to source in Github" }
      )
    end,
  },

  -- enable GHE/Github links with :Gbrowse
  {
    "tpope/vim-rhubarb",
    config = function()
      if require("custom.config").stripe.machine then
        vim.g.github_enterprise_urls = { "https://git.corp.stripe.com" }
      end
    end,
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
