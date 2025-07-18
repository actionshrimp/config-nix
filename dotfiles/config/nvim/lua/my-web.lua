local M = {}
M.init = function()
  -- :lua print(vim.bo.filetype)
  -- require("lspconfig").tailwindcss.setup({})

  vim.lsp.enable("tailwindcss")
  vim.lsp.config("tailwindcss", {})
end
return M
