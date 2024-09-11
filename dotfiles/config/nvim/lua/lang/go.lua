local M = {}
M.init = function()
  require("lspconfig").gopls.setup({})
end
return M
