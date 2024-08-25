local M = {}
M.plugins = function()
  return {
    { "neovim/nvim-lspconfig" },
    {
      "kosayoda/nvim-lightbulb",
      config = function()
        require("nvim-lightbulb").setup({
          autocmd = { enabled = true },
          sign = {
            enabled = false,
          },
          virtual_text = {
            enabled = true,
          },
        })
      end,
    },
  }
end
return M
