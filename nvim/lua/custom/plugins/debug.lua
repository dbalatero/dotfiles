-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  "mfussenegger/nvim-dap",
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = {
        -- Currently manually installing this debugger.
        {
          "microsoft/vscode-js-debug",
          build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        },
      },
    },

    -- Golang
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- I don't know if this is working here.
    --
    -- This is currently doing nothing for me - in theory, maybe this can
    -- replace "microsoft/vscode-js-debug"
    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      automatic_installation = true,
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "js", -- JS/TS
        "codelldb", -- Rust
        "delve", -- Go
      },
      handlers = {},
    })

    -- Basic debugging keymaps, feel free to change to your liking!
    --
    -- I suspect this should be one key:
    -- https://twitter.com/id_aa_carmack/status/566426468834889728?lang=eu
    --
    -- TODO: change these to single keys
    --   F2, F3, F4, F5
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>dst", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set breakpoint" })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     Golang setup                                         │
    --  ╰──────────────────────────────────────────────────────────╯
    require("dap-go").setup()

    --  ╭──────────────────────────────────────────────────────────╮
    --  │     TypeScript setup                                     │
    --  ╰──────────────────────────────────────────────────────────╯
    require("dap-vscode-js").setup({
      -- Maybe Mason makes this unnecessary
      -- OR I just have trawl somewhere else and figure out where Mason put it
      debugger_path = require("dotfiles").plugin_path() .. "/vscode-js-debug",
    })

    -- TODO: get TypeScript actually working, but JavaScript _does_ work.
    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        -- TODO: see about integrating with neotest-jest
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end
  end,
}
