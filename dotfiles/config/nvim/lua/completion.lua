local M = {}
M.plugins = function()
  return {
    {
      "echasnovski/mini.completion",
      version = "*",
      config = function()
        require("mini.completion").setup()
      end,
    },
  }
end
return M
