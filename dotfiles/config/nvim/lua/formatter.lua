local M = {}
M.plugins = function()
  return { {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
      -- :lua print(vim.bo.filetype)
      formatters_by_ft = {
        javascript = { "prettier" },
        json = { "prettier" },
        typescriptreact = { "prettier" },
        lua = { "stylua" }

      },
    },
  } }
end

M.init = function()
  vim.keymap.set('n', '<LEADER>m=b', vim.lsp.buf.format);
end
return M
