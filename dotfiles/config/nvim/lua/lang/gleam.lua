local M = {}
M.init = function()
  require("lspconfig").gleam.setup({ autostart = false })

  require("direnv-nvim").on_direnv_finished({ filetype = { "gleam" } }, function()
    vim.cmd("LspStart")
  end)
end
return M
