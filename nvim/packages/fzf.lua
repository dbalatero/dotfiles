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

local function FZFPromixitySort()
  local rg_command = "rg --files --hidden --glob '!{node_modules/*,.git/*}'"
  local base = vim.api.nvim_eval("fnamemodify(expand('%'), ':h:.:S')")
  local command = nil

  if base == "." or not proximity_sort_exists then
    command = rg_command
  else
    local file = vim.api.nvim_eval("expand('%')")
    command = rg_command .. " | " .. proximity_sort_path .. " " .. file
  end

  return require("fzf-lua").fzf_exec(command, {
    actions = require("fzf-lua").defaults.actions.files,
    previewer = require("fzf-lua").defaults.previewers.bat,
  })
end

return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        "telescope",
        files = {
          actions = {
            ["ctrl-Q"] = { require("fzf-lua.actions").file_sel_to_ll },
            ["ctrl-q"] = { require("fzf-lua.actions").file_sel_to_qf },
            ["ctrl-t"] = { require("fzf-lua.actions").file_tabedit },
            ["ctrl-v"] = { require("fzf-lua.actions").file_vsplit },
            ["ctrl-x"] = { require("fzf-lua.actions").file_split },
            enter = { require("fzf-lua.actions").file_edit_or_qf },
          },
          -- pay server can't take it
          file_icons = false,
          git_icons = false,
        },
        fzf_color = true,
        git = {
          file_icons = false,
          git_icons = false,
        },
        grep = {
          file_icons = false,
          git_icons = false,
        },
        winopts = { preview = { layout = "vertical" } },
      })

      vim.keymap.set("n", "<leader><space>", FZFPromixitySort, { desc = "FZF: Find files" })

      vim.keymap.set("n", "<leader>sb", function()
        require("fzf-lua").buffers({
          sort_lastused = true,
          sort_mru = true,
        })
      end, { desc = "FZF: Switch buffers", silent = true })

      vim.keymap.set("n", "<leader>sg", function()
        require("fzf-lua").live_grep({})
      end, { desc = "FZF: Grep files", silent = true })

      vim.keymap.set("n", "<leader>sm", function()
        require("fzf-lua").marks({})
      end, { desc = "FZF: Search marks", silent = true })

      vim.keymap.set("n", "<leader>sw", function()
        require("fzf-lua").grep_cword({})
      end, { desc = "FZF: Grep for current word", silent = true })
    end,
  },
}
