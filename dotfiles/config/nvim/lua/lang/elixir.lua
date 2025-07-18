local M = {}
M.init = function()
  -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
  vim.lsp.enable("elixirls")
  vim.lsp.config("elixirls", {
    autostart = false,
    cmd = { "elixir-ls" },
    -- set default capabilities for cmp lsp completion source
    -- capabilities = capabilities,
  })
end
return M
