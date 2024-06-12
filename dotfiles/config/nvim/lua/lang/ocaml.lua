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
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "reason" },
          callback = function(ev)
            -- vim.lsp.start({
            --   name = "ocaml-lsp-server",
            --   cmd = { "ocamllsp" },
            --   root_dir = vim.fs.root(ev.buf, { "dune-project" }),
            -- })

            vim.lsp.start({
              name = "tailwindcss-language-server",
              cmd = { "tailwindcss-language-server" },
              root_dir = vim.fs.root(ev.buf, { "dune-project" }),
            })
          end,
        })
      end,
    },
  }
end
return M
