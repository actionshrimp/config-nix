local M = {}

M.init = function()
  -- example to setup lua_ls and enable call snippets
  require("lspconfig").lua_ls.setup({
    settings = {
      Lua = {
        -- completion = {
        --   callSnippet = "Replace"
        -- }
      },
    },
  })
end
return M
