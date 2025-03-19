local M = {}
M.init = function()
  vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no")
end
return M
