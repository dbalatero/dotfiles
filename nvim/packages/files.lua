--  ╭──────────────────────────────────────────────────────────╮
--  │   File management                                        │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "Shougo/vimfiler.vim",
    config = function()
      vim.g.vimfiler_force_overwrite_statusline = 0
      vim.g.vimfiler_as_default_explorer = 1
      vim.g.vimshell_force_overwrite_statusline = 0

      vim.fn["vimfiler#custom#profile"]("default", "context", { safe = 0 })

      -- bind the minus key to show the file explorer in the dir of the current open
      -- buffer's file
      vim.keymap.set({ "n" }, "-", ":VimFilerBufferDir<CR>", {
        noremap = true,
        silent = true,
        desc = "Navigate to current directory",
      })
    end,
    dependencies = { "Shougo/unite.vim" },
  },
}
