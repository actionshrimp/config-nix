local M = {}
--local function init()
--  vim.api.nvim_create_autocmd('FileType', {
--    pattern = 'lua',
--    callback = function(ev)
--      vim.lsp.start({
--        name = 'lua-language-server',
--        cmd = { 'lua-language-server' },
--        root_dir = vim.fs.root(ev.buf, { '.luarc.json' }),
--      })
--    end,
--  })
--end

M.init = function()
  -- then setup your lsp server as usual
  local lspconfig = require('lspconfig')

  -- example to setup lua_ls and enable call snippets
  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        -- completion = {
        --   callSnippet = "Replace"
        -- }
      }
    }
  })
end
return M
