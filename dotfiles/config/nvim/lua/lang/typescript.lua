local M = {}
M.init = function()
  require("lspconfig").denols.setup({ autostart = false })
end
return M
