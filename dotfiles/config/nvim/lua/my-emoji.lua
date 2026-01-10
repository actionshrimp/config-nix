local M = {}
M.plugins = function()
  return {
    {
      "allaman/emoji.nvim",
      version = "1.0.0", -- optionally pin to a tag
      ft = "*", -- adjust to your needs
      dependencies = {
        -- util for handling paths
        "nvim-lua/plenary.nvim",
        -- optional for nvim-cmp integration
        -- "hrsh7th/nvim-cmp",
      },
      opts = {
        -- default is false, also needed for blink.cmp integration!
        enable_cmp_integration = true,
      },
      config = function(_, opts)
        require("emoji").setup(opts)
      end,
    },
  }
end

M.init = function() end
return M
