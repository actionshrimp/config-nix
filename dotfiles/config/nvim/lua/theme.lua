local M = {}
M.plugins = function()
  return {
    {
      "rebelot/kanagawa.nvim",
      config = function()
        vim.cmd.colorscheme("kanagawa")
      end,
    },
    -- {
    --   "folke/tokyonight.nvim",
    --   lazy = false,
    --   priority = 1000,
    --   opts = {},
    --   config = function()
    --     vim.cmd.colorscheme('tokyonight')
    --   end
    -- }
  }
end
return M
