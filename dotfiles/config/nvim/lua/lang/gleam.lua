local M = {}
M.init = function()
  vim.lsp.enable("gleam")
  vim.lsp.config("gleam", { autostart = false })
end
return M
