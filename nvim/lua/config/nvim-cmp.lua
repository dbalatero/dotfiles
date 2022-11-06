--  ╭──────────────────────────────────────────────────────────╮
--  │ 3rd party plugins                                        │
--  ╰──────────────────────────────────────────────────────────╯
local lspkind = require('lspkind')

-- Setup icons in the completion window.
lspkind.init()

--  ╭──────────────────────────────────────────────────────────╮
--  │ nvim-cmp setup                                           │
--  ╰──────────────────────────────────────────────────────────╯
local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')
local compare = require('cmp.config.compare')
local luasnip = require("luasnip")

-- I didn't write this shit https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  formatting = {
    format = lspkind.cmp_format(),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>`
    -- mapping.
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      s = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    }),
    ["<S-Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      s = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end
    }),
    -- Accept currently selected item. Set `select` to `false` to only confirm
    -- explicitly selected items.
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        local autocompleteOpen = cmp.visible()
        local hasSnippet = luasnip.expandable()

        if hasSnippet then
          if autocompleteOpen then
            cmp.close()
          end

          luasnip.expand()
        elseif autocompleteOpen then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      c = function(fallback)
        -- On the command line, we only want to select from the autocomplete
        -- menu if we've actually tabbed to an item. Otherwise, we just want to
        -- fire the search/command/whatever we've typed in and not get hassled
        -- by the autocomplete.
        local selected = cmp.get_selected_entry()

        if cmp.visible() and selected then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For ultisnips users.
  }, {
    {
      name = 'buffer',
      option = {
        -- Complete from all visible buffers.
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      },
    },
  }),
  sorting = {
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

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work
-- anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't
-- work anymore).
cmp.setup.cmdline(':', {
  completion = { autocomplete = false },
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
