local M = {}
M.plugins = function()
  return {
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      config = function()
        require("dashboard").setup({

          theme = "hyper",
          config = {
            week_header = {
              enable = true,
            },
            shortcut = {
              { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
              {
                desc = " Projects",
                group = "DiagnosticHint",
                action = "Telescope projects",
                key = "p",
              },
              {
                icon = " ",
                icon_hl = "@variable",
                desc = "Files",
                group = "Label",
                action = "Telescope find_files",
                key = "f",
              },
              {
                desc = " Apps",
                group = "DiagnosticHint",
                action = "Telescope apps",
                key = "a",
              },
              {
                desc = " dotfiles",
                group = "Number",
                action = "Telescope dotfiles",
                key = "d",
              },
            },
          },
        })
      end,
      dependencies = { { "nvim-tree/nvim-web-devicons" } },
    },
  }
end
return M
