local M = {}
M.init = function()
  local util = require("lspconfig.util")
  require("lspconfig").denols.setup({
    single_file_support = false, -- needed otherwise root_dir is ignored
    root_dir = util.root_pattern({ "deno.json" }),
    autostart = false,
  })
  require("lspconfig").ts_ls.setup({
    single_file_support = false, -- needed otherwise root_dir is ignored
    root_dir = util.root_pattern({ "tsconfig.json" }),
    autostart = false,
  })
end
return M
