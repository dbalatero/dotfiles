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

      -- require the :Sgbrowse command
      require("sourcegraph")

      -- Add new unified browse command
      vim.api.nvim_create_user_command("Browse", function(opts)
        -- Check if we're in a stripe-internal repo
        local remote_url =
          vim.fn.system("git config --get remote.origin.url"):gsub("%s+$", "")
        if remote_url:match("stripe%-internal") then
          -- Use Sgbrowse for stripe-internal repos
          if opts.range == 0 then
            -- No range, use the whole file
            vim.cmd("Sgbrowse")
          else
            -- Pass along the range
            vim.cmd(opts.line1 .. "," .. opts.line2 .. "Sgbrowse")
          end
        else
          -- Use Gbrowse for other repos
          if opts.bang then
            -- With bang (!) - copy to clipboard only
            if opts.range == 0 then
              vim.cmd("GBrowse!")
            else
              vim.cmd(opts.line1 .. "," .. opts.line2 .. "GBrowse!")
            end
          else
            -- Without bang - open in browser
            if opts.range == 0 then
              vim.cmd("GBrowse")
            else
              vim.cmd(opts.line1 .. "," .. opts.line2 .. "GBrowse")
            end
          end
        end
      end, { range = true, bang = true })

      vim.api.nvim_set_keymap(
        "v",
        "<leader>g",
        ":<C-u>'<,'>Browse!<CR>",
        { noremap = true, desc = "Copy link to source (GitHub/Sourcegraph)" }
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
