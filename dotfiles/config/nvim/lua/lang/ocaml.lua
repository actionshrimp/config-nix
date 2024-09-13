local M = {}
M.init = function()
  -- :lua print(vim.bo.filetype)
  require("lspconfig").ocamllsp.setup({})
end

M.plugins = function()
  return {
    {
      "reasonml-editor/vim-reason-plus",
      config = function()
        vim.cmd.set("commentstring=//\\ %s")
      end,
    },
  }
end
return M
