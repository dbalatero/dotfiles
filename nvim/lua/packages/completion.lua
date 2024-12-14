--  ╭──────────────────────────────────────────────────────────╮
--  │   Completion                                             │
--  ╰──────────────────────────────────────────────────────────╯

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
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
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
      "hrsh7th/cmp-buffer",
      {
        -- add vscode-style icons to completion menu
        "onsails/lspkind-nvim",
        config = function()
          require("lspkind").init()
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_buffer = require("cmp_buffer")
      local compare = require("cmp.config.compare")
      local luasnip = require("luasnip")

      cmp.setup({
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            max_width = 50,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({
                behavior = cmp.SelectBehavior.Insert,
              })
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({
                behavior = cmp.SelectBehavior.Insert,
              })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          {
            name = "buffer",
            option = {
              -- Complete from all visible buffers.
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            -- Sort by distance of the word from the cursor
            -- https://github.com/hrsh7th/cmp-buffer#locality-bonus-comparator-distance-based-sorting
            function(...)
              return cmp_buffer:compare_locality(...)
            end,
            compare.offset,
            compare.exact,
            compare.score,
            require("cmp-under-comparator").under,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      })
    end,
  },
}
