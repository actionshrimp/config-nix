local M = {}
M.init = function()
  -- :lua print(vim.bo.filetype)
  vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.iml]])
  vim.cmd([[autocmd BufRead,BufNewFile *.iml set filetype=iml]])

  vim.treesitter.language.register("ocaml", "iml")

  require("lspconfig").ocamllsp.setup({
    autostart = false,
    filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune", "iml" },
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "reason",
    callback = function(ev)
      vim.cmd.set("commentstring=//\\ %s")
    end,
  })
end

M.plugins = function()
  return {
    {
      "reasonml-editor/vim-reason-plus",
    },
  }
end
return M
