--  ╭──────────────────────────────────────────────────────────╮
--  │   Editing                                                │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "rmagatti/auto-session",
    lazy = false,

    opts = {
      suppressed_dirs = {
        "~/",
        "~/Projects",
        "~/Downloads",
        "/",
      },
      -- log_level = 'debug',
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      vim.keymap.set(
        { "n" },
        "<leader>nc",
        ":lua require('neogen').generate({ type = 'class' })<CR>",
        { noremap = true, silent = true, desc = "Generate [c]lass annotations" }
      )
      vim.keymap.set(
        { "n" },
        "<leader>nf",
        ":lua require('neogen').generate()<CR>",
        { noremap = true, silent = true, desc = "Generate [f]unction annotations" }
      )
    end,
    opts = {
      snippet_engine = "luasnip",
    },
  },
  -- Splitjoin like plugin
  {
    "AndrewRadev/splitjoin.vim",
    config = function()
      -- Disable the default keybindings so we can bind it below
      vim.g.splitjoin_split_mapping = ""
      vim.g.splitjoin_join_mapping = ""
    end,
  },

  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })

      -- Configure a fallback to splitjoin.vim when a language is not supported.
      local langs = require("treesj.langs")["presets"]

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "*",
        callback = function()
          if langs[vim.bo.filetype] then
            vim.keymap.set("n", "gS", "<Cmd>TSJSplit<CR>", { buffer = true, desc = "[S]plit under cursor" })
            vim.keymap.set("n", "gJ", "<Cmd>TSJJoin<CR>", { buffer = true, desc = "[J]oin under cursor" })
          else
            vim.keymap.set(
              "n",
              "gS",
              "<Cmd>SplitjoinSplit<CR>",
              { buffer = true, desc = "[S]plit under cursor" }
            )
            vim.keymap.set(
              "n",
              "gJ",
              "<Cmd>SplitjoinJoin<CR>",
              { buffer = true, desc = "[J]oin under cursor" }
            )
          end
        end,
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- marks in gutter
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})

      vim.keymap.set("n", "<leader>m<space>", ":delm! | delm A-Z0-9<CR>", {
        desc = "Delete all marks",
        silent = true,
        noremap = true,
      })
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- lets you surround comments in a box.
  {
    "LudoPinelli/comment-box.nvim",
    config = function()
      vim.keymap.set(
        { "n", "v" },
        "<leader>bb",
        require("comment-box").llbox,
        { noremap = true, desc = "Left-aligned comment box" }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>bc",
        require("comment-box").lcbox,
        { noremap = true, desc = "Centered comment box" }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>bc",
        require("comment-box").lrbox,
        { noremap = true, desc = "Right-aligned comment box" }
      )
    end,
  },

  -- switch syntaxes around with `gs`
  "AndrewRadev/switch.vim",

  -- strip whitespace
  {
    "cappyzawa/trim.nvim",
    opts = {},
  },

  -- cs`' to change `` to '', etc
  "tpope/vim-surround",

  -- <leader>q to toggle quickfix
  "milkypostman/vim-togglelist",

  -- snake_case -> camelCase, etc
  "tpope/vim-abolish",

  -- remaps .
  "tpope/vim-repeat",

  -- :AV :AS for alternate files
  "tpope/vim-projectionist",

  {
    url = "git@git.corp.stripe.com:nms/payjectionist.nvim.git",
    cond = require("custom.config").stripe.utils.is_stripe_machine,
  },
}
