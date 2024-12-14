local M = {}

M.build_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  return capabilities
end

--  This function gets run when an LSP connects to a particular buffer.
M.on_attach = function(client, bufnr)
  -- lsp_format.on_attach(client)

  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(modes, keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc })
  end

  local nmap = function(keys, func, desc)
    return map("n", keys, func, desc)
  end

  local nvmap = function(keys, func, desc)
    return map({ "n", "v" }, keys, func, desc)
  end

  nmap("<leader>li", ":LspInfo<CR>", "[I]nfo")
  nmap("<leader>lr", vim.lsp.buf.rename, "[R]ename")
  nvmap("<leader>lc", vim.lsp.buf.code_action, "[C]ode Action")
  nmap("<leader>lx", ":LspRestart<CR>", "Restart LSP in buffer")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  -- nmap("<leader>ld", require("telescope.builtin").lsp_document_symbols, "[D]ocument Symbols")
  -- nmap(
  --   "<leader>lws",
  --   require("telescope.builtin").lsp_dynamic_workspace_symbols,
  --   "[W]orkspace [S]ymbols"
  -- )

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- TODO: find another key
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>lwa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

return M
