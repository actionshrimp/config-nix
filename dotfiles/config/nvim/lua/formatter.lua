local M = {}
M.plugins = function ()
  return { { 'stevearc/conform.nvim', opts = {}, } }
end

M.init = function ()
  vim.keymap.set('n', '<LEADER>m=b', vim.lsp.buf.format);
end
return M
