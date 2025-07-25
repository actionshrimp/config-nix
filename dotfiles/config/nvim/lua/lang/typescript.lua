local M = {}
M.init = function()
  local util = require("lspconfig.util")

  vim.lsp.enable("denols")
  vim.lsp.config("denols", {
    single_file_support = false, -- needed otherwise root_dir is ignored
    root_dir = util.root_pattern({ "deno.json" }),
    autostart = false,
  })

  vim.lsp.enable("ts_ls")
  -- vim.lsp.config("ts_ls", {
  --   -- single_file_support = false, -- needed otherwise root_dir is ignored
  --   -- root_dir = util.root_pattern({ "tsconfig.json" }),
  --   -- autostart = false,
  -- })

  vim.lsp.enable("eslint")
end
return M
