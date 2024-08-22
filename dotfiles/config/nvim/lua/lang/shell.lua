local M = {}
M.init = function()
  require("lspconfig").bashls.setup({})
end
return M
