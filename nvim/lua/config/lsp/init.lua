local lspconfig = require('lspconfig')
local lsp_format = require("lsp-format")
local lsp_status = require("lsp-status")

-- gutter space for lsp info on left
vim.cmd [[set signcolumn=yes]]

-- 300ms before CursorHold events fire (like hover text on errors)
vim.cmd [[set updatetime=300]]

--  ╭──────────────────────────────────────────────────────────╮
--  │ LSP format                                               │
--  ╰──────────────────────────────────────────────────────────╯
lsp_format.setup()

--  ╭──────────────────────────────────────────────────────────╮
--  │ LSP status                                               │
--  ╰──────────────────────────────────────────────────────────╯

-- Setup LSP statusline
lsp_status.register_progress()

-- gutter space for lsp info on left
vim.cmd [[set signcolumn=yes]]

-- 300ms before CursorHold events fire (like hover text on errors)
vim.cmd [[set updatetime=300]]

--  ╭──────────────────────────────────────────────────────────╮
--  │ LSP format                                               │
--  ╰──────────────────────────────────────────────────────────╯
lsp_format.setup()

--  ╭──────────────────────────────────────────────────────────╮
--  │ LSP status                                               │
--  ╰──────────────────────────────────────────────────────────╯

-- Setup LSP statusline
lsp_status.register_progress()

--  ╭──────────────────────────────────────────────────────────╮
--  │ Default config for new LSPs                              │
--  ╰──────────────────────────────────────────────────────────╯
local shared = require('config.lsp.shared')

lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = shared.default_capabilities,
    on_attach = shared.on_attach,
  }
)

--  ╭──────────────────────────────────────────────────────────╮
--  │ Core keybinds                                            │
--  ╰──────────────────────────────────────────────────────────╯

vim.cmd [[
  nnoremap <silent><space>la :CodeActionMenu<CR>
  nnoremap <silent> <space>l0  <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> <space>ld  <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <space>li  :LspInfo<CR>
  nnoremap <silent> <space>lh  <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <space>lk  <cmd>lua vim.diagnostic.open_float({scope="line"})<CR>
  nnoremap <silent> <space>lD  <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> <space>ln  <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> <space>lr  <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> <space>lt  <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> <space>lw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
]]

--  ╭──────────────────────────────────────────────────────────╮
--  │ Diagnostics                                              │
--  ╰──────────────────────────────────────────────────────────╯
vim.cmd [[
  nnoremap <silent> gj :lua vim.diagnostic.goto_next()<cr>
  nnoremap <silent> gk :lua vim.diagnostic.goto_prev()<cr>
]]

-- Only show the first line when showing diagnostics, to avoid spewing too
-- much out into the editor.
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
})

--  ╭──────────────────────────────────────────────────────────╮
--  │ Load all the LSP-specific configs (null_ls, etc)         │
--  ╰──────────────────────────────────────────────────────────╯
require('config.utils').requireConfigDirectory('lsp/support')
