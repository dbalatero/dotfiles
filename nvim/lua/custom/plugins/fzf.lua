local function file_exists(name)
  local f = io.open(name, "r")

  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local proximity_sort_path = os.getenv("HOME") .. "/.cargo/bin/proximity-sort"
local proximity_sort_exists = file_exists(proximity_sort_path)

local fzf_proximity_files = function()
  local rg_command = "rg --files --hidden --glob '!{node_modules/*,.git/*}'"
  local base = vim.api.nvim_eval("fnamemodify(expand('%'), ':h:.:S')")
  local command = nil

  if base == "." or not proximity_sort_exists then
    command = rg_command
  else
    local file = vim.api.nvim_eval("expand('%')")
    command = rg_command .. " | " .. proximity_sort_path .. " " .. file
  end

  require("fzf-lua").files({
    raw_cmd = command,
  })
end

return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua.actions")

    require("fzf-lua").setup({
      fzf_opts = {
        ["--layout"] = false,
      },
      files = {
        actions = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-x"] = actions.file_split,
          ["ctrl-v"] = actions.file_vsplit,
          ["ctrl-t"] = actions.file_tabedit,
          ["alt-q"] = actions.file_sel_to_qf,
        },
        -- pay-server can't take the heat
        file_icons = false,
        git_icons = false,
      },
      git = {
        file_icons = false,
        git_icons = false,
      },
      grep = {
        file_icons = false,
        git_icons = false,
      },
      winopts = {
        preview = {
          layout = "vertical",
        },
      },
    })

    -- Trying to wean myself off of Ctrl P...
    -- vim.keymap.set(
    --   { "n" },
    --   "<C-p>",
    --   fzf_proximity_files,
    --   { noremap = true, desc = "FZF: Find files" }
    -- )

    vim.keymap.set(
      { "n" },
      "<space>ff",
      fzf_proximity_files,
      { noremap = true, desc = "FZF: Find files" }
    )
    vim.keymap.set(
      { "n" },
      "<space>fg",
      require("fzf-lua").grep,
      { noremap = true, desc = "FZF: Search by grep" }
    )
    vim.keymap.set(
      { "n" },
      "<space>fw",
      require("fzf-lua").grep_cword,
      { noremap = true, desc = "FZF: Grep for word" }
    )
  end,
}
