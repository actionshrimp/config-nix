local M = {}
M.init = function()
  require("lspconfig").gopls.setup({ autostart = false })
  require("lspconfig").golangci_lint_ls.setup({ autostart = false })
end
return M
