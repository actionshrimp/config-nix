local M = {}
M.init = function()
  require("lspconfig").gleam.setup({ autostart = false })
end
return M
