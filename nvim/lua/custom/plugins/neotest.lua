--  ╭──────────────────────────────────────────────────────────╮
--  │ Neotest                                                  │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",

      -- Languages
      "haydenmeade/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({}),
        },
      })
    end,
  },
}
