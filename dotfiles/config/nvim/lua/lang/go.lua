local M = {}
M.init = function()
  vim.lsp.enable("gopls")
  vim.lsp.config("gopls", { autostart = false })

  vim.lsp.enable("golangci_lint_ls")
  vim.lsp.config("golangci_lint_ls", { autostart = false })
end
return M
