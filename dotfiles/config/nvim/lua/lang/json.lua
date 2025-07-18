local M = {}
M.init = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function(ev)
      vim.cmd.set("commentstring=//\\ %s")

      vim.lsp.start({
        name = "vscode-json-languageserver",
        cmd = { "vscode-json-languageserver", "--stdio" },
      })
    end,
  })
end
return M
