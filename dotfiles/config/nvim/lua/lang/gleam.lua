local M = {}
M.init = function()
  require("lspconfig").gleam.setup({})
end
return M
