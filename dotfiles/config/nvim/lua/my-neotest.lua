local M = {}
M.plugins = function()
  return {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MarkEmmons/neotest-deno",
    },
    config = function()
      require("neotest").setup({
        debug = true,
        adapters = {
          require("neotest-deno"),
        },
      })

      require("which-key").add({
        { "<leader>mtt", require("neotest").run.run, desc = "Nearest" },
        { "<leader>mts", require("neotest").summary.toggle, desc = "Summary" },
        {
          "<leader>mtf",
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end,
          desc = "File",
        },
      })
    end,
  }
end
return M
