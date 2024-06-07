local M = {}
M.plugins = function()
  return {
    {
      "ramilito/kubectl.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        {
          "<leader>ak",
          function()
            require("kubectl").open()
          end,
          desc = "Kubectl",
        },
      },
      config = function()
        require("kubectl").setup()
      end,
    },
  }
end
return M
