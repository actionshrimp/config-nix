local M = {}
M.plugins = function()
  return {
    {
      "nvimdev/lspsaga.nvim",
      config = function()
        require("lspsaga").setup({
          lightbulb = {
            enable = false,
            virtual_text = false,
          },
        })
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional
        "nvim-tree/nvim-web-devicons", -- optional
      },
    },
    { "neovim/nvim-lspconfig" },
    { "jose-elias-alvarez/null-ls.nvim" },
  }
end
return M
