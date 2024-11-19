local M = {}
M.plugins = function()
  return {
    {
      "epwalsh/pomo.nvim",
      version = "*", -- Recommended, use latest release instead of latest commit
      lazy = true,
      cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
      dependencies = {
        -- Optional, but highly recommended if you want to use the "Default" timer
        "rcarriga/nvim-notify",
      },
      config = function()
        require("pomo").setup({
          sessions = {
            work = {
              { name = "Work", duration = "25m" },
            },
          },
        })
      end,
    },
  }
end
M.init = function()
  require("which-key").add({
    {
      mode = "n",
      { "<leader>ap", group = "Pomodoro" },
      { "<leader>app", ":TimerSession work<CR>", desc = "Start" },
      { "<leader>apP", ":TimerPause<CR>", desc = "Pause" },
      { "<leader>aps", ":TimerStop<CR>", desc = "Stop" },
      { "<leader>aph", ":TimerHide<CR>", desc = "Hide" },
      { "<leader>apv", ":TimerShow<CR>", desc = "View" },
    },
  })
end
return M
