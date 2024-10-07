local M = {}
M.init = function()
  require("lspconfig").gopls.setup({ autostart = false })
  require("lspconfig").golangci_lint_ls.setup({ autostart = false })

  require("direnv-nvim").on_direnv_finished({ filetype = { "go" } }, function()
    vim.cmd("LspStart")
  end)
end
return M
