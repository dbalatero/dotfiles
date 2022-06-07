local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local lsp_status = require('lsp-status')
local lspkind = require('lspkind')
local trouble = require('trouble')
local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')
local compare = require('cmp.config.compare')

trouble.setup({
  use_diagnostic_signs = true,
})

-- Shared on_attach + capabilities
--
-- We set these on the `default_config` so we don't have to set up `on_attach`
-- and `capabilities` for every last LSP.
local on_attach = function(client, bufnr)
  lsp_status.on_attach(client, bufnr)

  -- Floating window signature
  require('lsp_signature').on_attach({
    debug = false,
    handler_opts = {
      border = "single",
    },
  })

  -- print(vim.inspect(client.resolved_capabilities))
end

lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = lsp_status.capabilities,
    on_attach = on_attach,
  }
)

-- capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = {
      spacing = 4,
      format = function(diagnostic)
        -- Only show the first line with virtualtext.
        return string.gsub(diagnostic.message, '\n.*', '')
      end,
    },
    signs = true,
    update_in_insert = false,
  }
)

-- Completion
lspkind.init() -- setup icons

-- setup nvim-cmp
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  formatting = {
    format = lspkind.cmp_format(),
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
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
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          feedkey("<Plug>(ultisnips_jump_forward)", 'm')
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          feedkey("<Plug>(ultisnips_jump_forward)", 'm')
        else
          fallback()
        end
      end
    }),
    ["<S-Tab>"] = cmp.mapping({
      c = function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return feedkey("<Plug>(ultisnips_jump_backward)", 'm')
        else
          fallback()
        end
      end,
      s = function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          return feedkey("<Plug>(ultisnips_jump_backward)", 'm')
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
        local hasSnippet = vim.api.nvim_eval([[ UltiSnips#CanExpandSnippet() ]]) == 1

        if hasSnippet then
          if autocompleteOpen then
            cmp.close()
          end

          feedkey("<cmd>call UltiSnips#ExpandSnippet()<CR>", "m")
        elseif autocompleteOpen then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
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

local lspCapabilities = require('cmp_nvim_lsp')
  .update_capabilities(vim.lsp.protocol.make_client_capabilities())

---------------------------------

-- vim.lsp.set_log_level("debug")

-- Setup LSP statusline
lsp_status.register_progress()

-- Flow
lspconfig.flow.setup({
  capabilities = lspCapabilities,
  cmd = { 'node_modules/.bin/flow', 'lsp' },
})

-- Lua
local sumneko_cmd

if vim.fn.executable("lua-language-server") == 1 then
  sumneko_cmd = {"lua-language-server"}
else
  local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/nvim/lsp/lua-language-server"
  local bin_path = ""

  if vim.fn.executable(sumneko_root_path .. "/bin/macOS/lua-language-server") == 1 then
    bin_path = sumneko_root_path .. "/bin/macOS/lua-language-server"
  else
    bin_path = sumneko_root_path .. "/bin/lua-language-server"
  end

  sumneko_cmd = {
    bin_path,
    "-E",
    sumneko_root_path .. "/main.lua",
  }
end

lspconfig.sumneko_lua.setup({
  capabilities = lspCapabilities,
  cmd = sumneko_cmd,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
})

-- Rust
lspconfig.rust_analyzer.setup({
  capabilities = lspCapabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
    }
  }
})

-- Emmet
lspCapabilities.textDocument.completion.completionItem.snippetSupport = true

if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = {'emmet-ls', '--stdio'};
      filetypes = {'html', 'css', 'blade', 'javascriptreact', 'javascript.jsx'};
      root_dir = function()
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end

lspconfig.emmet_ls.setup({
  capabilities = lspCapabilities,
})

lspconfig.tsserver.setup({
  capabilities = lspCapabilities,
  cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    maxTsServerMemory = "8192",
  },
  root_dir = lspconfig.util.root_pattern("tsconfig.json"),
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end

    on_attach(client, bufnr)
  end
})

-- Sorbet lsp for Stripe, if it exists
function setupVanillaLspClients()
  lspconfig.sorbet.setup({
    capabilities = lspCapabilities,
    root_dir = lspconfig.util.root_pattern("sorbet", ".git"),
  })
end

local _, stripeLsp = pcall(function()
  return require('stripe.lsp')
end)

local inStripe = stripeLsp and stripeLsp.setupClients

if inStripe then
  stripeLsp.setupClients(
    {
      capabilities = lspCapabilities,
    },
    setupVanillaLspClients
  )
else
  setupVanillaLspClients()
end
