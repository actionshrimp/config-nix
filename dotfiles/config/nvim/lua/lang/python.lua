local M = {}
M.init = function()
  vim.lsp.enable("pyright")
  vim.lsp.config("pyright", { autostart = false })

  vim.lsp.enable("ruff")
  vim.lsp.config("ruff", { autostart = false })
end
return M
