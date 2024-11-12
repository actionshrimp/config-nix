local M = {}
M.plugins = function()
  return {
    {
      "nvimdev/lspsaga.nvim",
      config = function()
        require("lspsaga").setup({})
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional
        "nvim-tree/nvim-web-devicons", -- optional
      },
    },
    { "neovim/nvim-lspconfig" },
    { "jose-elias-alvarez/null-ls.nvim" },
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
