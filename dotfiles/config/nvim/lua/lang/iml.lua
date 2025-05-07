local M = {}
M.plugins = function()
  return {}
end
M.init = function()
  require("lspconfig").terraform_lsp.setup({ autostart = false })
  require("lspconfig").tflint.setup({ autostart = false })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function(ev)
      vim.cmd.set("commentstring=#\\ %s")
    end,
  })
end
return M
