local M = {}
M.init = function()
  vim.lsp.enable("bashls")
  vim.lsp.config("bashls", { autostart = false })
end
return M
