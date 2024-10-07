local M = {}
M.init = function()
  require("lspconfig").pyright.setup({ autostart = false })

  require("direnv-nvim").on_direnv_finished({ filetype = { "python" } }, function()
    vim.cmd("LspStart")
  end)

  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.black,
    },
  })
end
return M
