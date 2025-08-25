local M = {}
M.plugins = function()
  return {
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      config = function()
        local s = require("snacks")
        require("dashboard").setup({
          theme = "hyper",
          config = {
            week_header = {
              enable = true,
            },
            shortcut = {
              { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            },
            project = {
              enable = true,
              limit = 8,
              action = function(path)
                s.picker.files({ cwd = path })
              end,
            },
          },
        })
      end,
      dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
  }
end
return M
