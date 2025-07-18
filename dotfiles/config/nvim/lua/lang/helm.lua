local M = {}
M.plugins = function() end
M.init = function()
  vim.filetype.add({
    extension = {
      gotmpl = "gotmpl",
    },
    pattern = {
      [".*/templates/.*%.tpl"] = "helm",
      [".*/templates/.*%.ya?ml"] = "helm",
      ["helmfile.*%.ya?ml"] = "helm",
    },
  })

  vim.lsp.enable("helm_ls")
  vim.lsp.config("helm_ls", { autostart = false })
end
return M
