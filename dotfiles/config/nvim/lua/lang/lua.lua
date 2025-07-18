local M = {}

M.init = function()
  -- example to setup lua_ls and enable call snippets
  vim.lsp.enable("lua_ls")
  vim.lsp.config("lua_ls", {
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
