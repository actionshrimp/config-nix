local function plugins()
  return { { 'stevearc/conform.nvim', opts = {}, } }
end

local function init()
  vim.keymap.set('n', '<LEADER>m=b', vim.lsp.buf.format);
end

return { plugins = plugins, init = init }
