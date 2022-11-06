local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local lsp_format = require("lsp-format")
local lsp_status = require('lsp-status')
local lspkind = require('lspkind')
local trouble = require('trouble')
local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')
local compare = require('cmp.config.compare')
local luasnip = require("luasnip")
local null_ls = require("null-ls")

-- Load the friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- I didn't write this shit https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

trouble.setup({
  use_diagnostic_signs = true,
})

lsp_format.setup()

-- Shared on_attach + capabilities
--
-- We set these on the `default_config` so we don't have to set up `on_attach`
-- and `capabilities` for every last LSP.
local on_attach = function(client, bufnr)
  lsp_format.on_attach(client, bufnr)
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

-- null ls
local ignorePrettierRules = function(diagnostic)
  return diagnostic.code ~= "prettier/prettier"
end

local hasEslintConfig = function(utils)
  return utils.root_has_file({
    ".eslintrc",
    ".eslintrc.json",
    ".eslintrc.js"
  })
end

local hasPrettierConfig = function(utils)
  return utils.root_has_file({
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.js",
    ".prettierrc.toml",
    ".prettierrc.yml",
    ".prettierrc.yaml",
  })
end

local eslintConfig = {
  condition = hasEslintConfig,
  filter = ignorePrettierRules,
}

null_ls.setup({
  -- For :NullLsLog support
  -- debug = true,
  on_attach = on_attach,
  root_dir = require("null-ls.utils").root_pattern(
    ".git",
    "Gemfile.lock",
    "package.json"
  ),
  sources = {
    -- prettier
    -- todo get prettierd configured and setup
    null_ls.builtins.formatting.prettier.with({
      condition = hasPrettierConfig,
      env = {
        -- PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
      },
      -- Always use the local prettier, especially when prettier is pointing
      -- at a feature branch.
      prefer_local = "node_modules/.bin",
    }),

    -- eslint
    null_ls.builtins.code_actions.eslint_d.with(eslintConfig),
    null_ls.builtins.diagnostics.eslint_d.with(eslintConfig),
    -- null_ls.builtins.formatting.eslint_d.with(eslintConfig),
  }
})

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

local lspCapabilities = require('cmp_nvim_lsp').default_capabilities()

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
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
  capabilities = lspCapabilities,
  -- cmd = sumneko_cmd,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          vim.fn.stdpath('config') .. '/lua'
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
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
      cmd = { 'emmet-ls', '--stdio' };
      filetypes = { 'html', 'css', 'blade', 'javascriptreact', 'javascript.jsx' };
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
  cmd = {
    'typescript-language-server',
    '--stdio',
    -- attempt to speed up TypeScript
    '--tsserver-path=' .. vim.fn.getenv("HOME") .. '/.nodenv/shims/tsserver',
  },
  cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    maxTsServerMemory = "8192",
    preferences = {
      -- Ensure we always import from absolute paths
      importModuleSpecifierPreference = "non-relative",
    },
  },
  root_dir = lspconfig.util.root_pattern("tsconfig.json"),
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end

    on_attach(client, bufnr)
  end
})

lspconfig.sorbet.setup({
  capabilities = lspCapabilities,
  root_dir = lspconfig.util.root_pattern("sorbet"),
})
