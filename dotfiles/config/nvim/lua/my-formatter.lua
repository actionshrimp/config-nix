local M = {}
M.plugins = function()
  return {
    {
      "stevearc/conform.nvim",
      config = function()
        vim.keymap.set("n", "<LEADER>m=b", vim.lsp.buf.format)
        require("conform").setup({
          async = true,
          format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 1000,
            lsp_fallback = true,
          },

          formatters = {
            ocamlformat_iml = {
              command = "ocamlformat",
              args = { "--impl", "--enable-outside-detected-project", "--name", "$FILENAME", "-" },
            },
          },

          -- :lua print(vim.bo.filetype)
          formatters_by_ft = {
            javascript = { "prettier" },
            json = { "prettier" },
            typescriptreact = { "prettier" },
            lua = { "stylua" },
            terraform = { "terraform_fmt" },
            nix = { "nixfmt" },
            ocaml = { "ocamlformat" },
            iml = { "ocamlformat_iml" },
          },
        })
      end,
    },
  }
end
return M
