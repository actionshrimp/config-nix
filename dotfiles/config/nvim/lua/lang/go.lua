local M = {}
M.init = function()
  require("lspconfig").gopls.setup({})
  require("lspconfig").golangci_lint_ls.setup({})
end
return M
