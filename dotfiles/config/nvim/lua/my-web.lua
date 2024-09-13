local M = {}
M.init = function()
  -- :lua print(vim.bo.filetype)
  require("lspconfig").tailwindcss.setup({})
end
return M
