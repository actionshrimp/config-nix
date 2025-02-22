local M = {}
M.plugins = function()
  return {
    {
      "MatrosMartz/neotest-deno",
    }, -- fork
    -- { "MarkEmmons/neotest-deno" }, --original
    { "nvim-neotest/neotest-plenary" },
    { "nvim-neotest/neotest-jest" },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-deno"),
            require("neotest-plenary"),
            require("neotest-jest")({
              jestCommand = "npx jest",
              jestConfigFile = "jest.config.json",
              env = { CI = true },
              cwd = function(path)
                return vim.fn.getcwd()
              end,
            }),
          },
        })

        require("which-key").add({
          {
            mode = { "n", "v" },
            { "<leader>mtt", require("neotest").run.run, desc = "Nearest" },
          },
          {
            mode = "n",
            { "<leader>mts", require("neotest").summary.toggle, desc = "Summary" },
            { "<leader>mto", require("neotest").output_panel.toggle, desc = "Output" },
            {
              "<leader>mtf",
              function()
                require("neotest").run.run(vim.fn.expand("%"))
              end,
              desc = "File",
            },
          },
        })
      end,
    },
  }
end
return M
