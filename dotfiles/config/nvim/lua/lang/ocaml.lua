local M = {}
M.init = function()
  -- :lua print(vim.bo.filetype)
  require("lspconfig").ocamllsp.setup({ autostart = false })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "reason",
    callback = function(ev)
      vim.cmd.set("commentstring=//\\ %s")
    end,
  })

  require("direnv-nvim").on_direnv_finished({ filetype = { "ocaml", "reason" } }, function()
    vim.cmd("LspStart")
  end)
end

M.plugins = function()
  return {
    {
      "reasonml-editor/vim-reason-plus",
    },
  }
end
return M
