--  ╭──────────────────────────────────────────────────────────╮
--  │   Completion                                             │
--  ╰──────────────────────────────────────────────────────────╯

local function custom_tab()
  local cmp = require("blink.cmp")

  print("custom_tab called")

  -- Handle snippet navigation first
  if cmp.snippet_active() then
    print("snippet active, moving forward")
    return cmp.snippet_forward()
  end

  -- If completion menu is visible, cycle through items
  if cmp.is_visible() then
    print("menu visible, selecting next")
    return cmp.select_next()
  else
    -- No menu, fallback to regular tab
    print("no menu, inserting tab")
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end

local function custom_shift_tab()
  local cmp = require("blink.cmp")

  print("custom_shift_tab called")

  -- Handle snippet navigation first
  if cmp.snippet_active() then
    print("snippet active, moving backward")
    return cmp.snippet_backward()
  end

  -- If completion menu is visible, cycle backwards
  if cmp.is_visible() then
    print("menu visible, selecting prev")
    return cmp.select_prev()
  else
    -- No menu, fallback to regular shift-tab
    print("no menu, inserting shift-tab")
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
  end
end

return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {}, -- Disable super-tab's Tab mapping so our custom one works
        ["<S-Tab>"] = {}, -- Disable super-tab's Shift-Tab mapping so our custom one works
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-d>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Set up custom Tab handlers to cycle through completions
      vim.keymap.set("i", "<Tab>", custom_tab, { desc = "Blink: Select next completion" })
      vim.keymap.set("i", "<S-Tab>", custom_shift_tab, { desc = "Blink: Select prev completion" })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")

      ls.config.setup({
        enable_autosnippets = true,
        history = true,
      })

      ls.add_snippets("all", {
        ls.snippet("todo", { ls.text_node("TODO(dbalatero): ") }),
      })
    end,
  },
}
