local M = {}
M.plugins = function()
  return {
    -- {
    --   "echasnovski/mini.notify",
    --   version = "*",
    --   config = function()
    --     require("mini.notify").setup({
    --       -- Use notification message as is
    --       format = function(notif)
    --         return notif.msg
    --       end,
    --       -- bottom right
    --       window = { config = { anchor = "SE" } },
    --     })
    --   end,
    -- },
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          top_down = false,
          timeout = 500,
          -- render = "compact",
          render = "default",
          stages = "static",
        })

        -- set vim-notify as the default notification handler
        vim.notify = require("notify")
      end,
    },
  }
end
return M
