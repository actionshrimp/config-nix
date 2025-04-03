local M = {}
M.plugins = function()
  return {}
end
M.init = function()
  vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
  vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
  vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
  vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
  vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

  vim.treesitter.language.register("hcl", "terraform")

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
