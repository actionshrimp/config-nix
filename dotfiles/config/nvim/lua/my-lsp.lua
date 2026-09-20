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
    {
      "nvimtools/none-ls.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
      },
      opts = {
        -- configurations go here
      },
    },
  }
end
return M
