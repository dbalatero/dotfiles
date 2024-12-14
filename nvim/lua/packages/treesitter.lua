return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- Show function context as you scroll
    "romgrk/nvim-treesitter-context",

    -- Add new text object support based on language
    "nvim-treesitter/nvim-treesitter-textobjects",

    -- Extended matchers for %
    "andymass/vim-matchup",

    -- Highlight parenthesis pairs w/ different colors
    "p00f/nvim-ts-rainbow",

    -- Auto close <html> tags
    "windwp/nvim-ts-autotag",
  },
  config = function()
    pcall(require("nvim-treesitter.install").update({ with_sync = true }))

    require("treesitter-context").setup({ max_lines = 2 })

    -- [[ Configure Treesitter ]]
    -- See `:help nvim-treesitter`
    require("nvim-treesitter.configs").setup({
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "elixir",
        "erlang",
        "go",
        "graphql",
        "help",
        "java",
        "javascript",
        "json",
        "kotlin",
        "lua",
        "nix",
        "php",
        "python",
        "regex",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<M-space>",
        },
      },
      textobjects = {
        enable = true,
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
      -- Plugins
      matchup = {
        enable = true,
      },
      rainbow = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    })
  end,
}
