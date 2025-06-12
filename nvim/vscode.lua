vim.api.nvim_create_user_command("TestConfig", function()
  print("Config loaded successfully!")
end, {})

vim.opt.clipboard:append("unnamedplus")

vim.keymap.set({ "n" }, "vv", function()
  vim.cmd([[call VSCodeNotify('workbench.action.splitEditorRight')]])
end)

vim.keymap.set({ "n" }, "ss", function()
  vim.cmd([[call VSCodeNotify('workbench.action.splitEditorDown')]])
end)
