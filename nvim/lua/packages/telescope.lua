-- Fuzzy Finder (files, lsp, etc)
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "princejoogie/dir-telescope.nvim",
      config = function()
        require("dir-telescope").setup({
          hidden = false,
          respect_gitignore = true,
        })

        require("telescope").load_extension("dir")
      end,
    },
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
      config = function()
        -- Enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")
      end,
    },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--glob",
          "!{node_modules/*,.git/*,.aws/*,.yarn/*}",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      pickers = {
        buffers = {
          ignore_current_buffer = true,
          sort_mru = true,
        },
        find_files = {
          layout_strategy = "vertical",
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob",
            "!{node_modules/*,.git/*,.aws/*,.yarn/*}",
            "--color=never",
          },
        },
        live_grep = {
          layout_strategy = "vertical",
        },
      },
    })

    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set(
      "n",
      "<leader>?",
      require("telescope.builtin").oldfiles,
      { desc = "[?] Find recently opened files" }
    )

    vim.keymap.set("n", "<leader><space>", function()
      require("telescope.builtin").find_files({
        layout_strategy = "vertical",
        -- path_display = { shorten = { exclude = { 1, 2, 3, -1 } } },
      })
    end, { desc = "[S]earch [F]iles" })

    vim.keymap.set("n", "<leader>sb", function()
      require("telescope.builtin").buffers({ ignore_current_buffer = true, sort_mru = true })
    end, { desc = "[S]earch existing buffers" })

    vim.keymap.set(
      "n",
      "<leader>sdf",
      require("telescope").extensions.dir.find_files,
      { desc = "[S]earch [d]irectory for [f]iles" }
    )

    vim.keymap.set("n", "<leader>sdg", function()
      require("telescope").extensions.dir.live_grep({
        layout_strategy = "vertical",
      })
    end, { desc = "[S]earch [d]irectory by [g]rep" })

    vim.keymap.set("n", "<leader>si", require("telescope.builtin").diagnostics, { desc = "[S]earch D[i]agnostics" })
    vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sg", function()
      require("telescope.builtin").live_grep({ layout_strategy = "vertical" })
    end, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set(
      "n",
      "<leader>sw",
      require("telescope.builtin").grep_string,
      { desc = "[S]earch current [W]ord" }
    )
  end,
}
