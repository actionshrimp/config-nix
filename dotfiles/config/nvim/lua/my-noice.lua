local M = {}
M.plugins = function()
  return {
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      config = function()
        require("noice").setup({
          -- add any options here
          cmdline = {
            format = {
              search_down = { view = "cmdline" },
              search_up = { view = "cmdline" },
            },
          },
          messages = {
            enabled = false,
          },
          notify = {
            enabled = false,
          },
          views = {
            cmdline_popup = {
              position = {
                row = 5,
                col = "50%",
              },
              size = {
                width = 60,
                height = "auto",
              },
            },
            popupmenu = {
              relative = "editor",
              position = {
                row = 8,
                col = "50%",
              },
              size = {
                width = 60,
                height = 10,
              },
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
              win_options = {
                winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
              },
            },
          },
        })
      end,
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
      },
    },
  }
end
return M
