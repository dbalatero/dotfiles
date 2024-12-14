--  ╭──────────────────────────────────────────────────────────╮
--  │   tmux                                                   │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      -- set our shell to be bash for fast tmux switching times
      -- see: https://github.com/christoomey/vim-tmux-navigator/issues/72
      vim.o.shell = "/bin/bash --norc -i"

      -- <C-K>       * :<C-U>TmuxNavigateUp<CR>
      vim.keymap.set({ "n" }, "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true, noremap = true })
    end,
  },

  {
    "RyanMillerC/better-vim-tmux-resizer",
    config = function()
      vim.g.tmux_resizer_no_mappings = 0
    end,
  },
}
