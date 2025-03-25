local M = {}
M.init = function()
  require("lspconfig").pyright.setup({ autostart = false })
  require("lspconfig").ruff.setup({ autostart = false })
end
return M
