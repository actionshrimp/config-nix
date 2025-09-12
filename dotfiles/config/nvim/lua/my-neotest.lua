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
      "marilari88/neotest-vitest",
      dev = true,
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "marilari88/neotest-vitest",
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-deno"),
            require("neotest-plenary"),
            -- require("neotest-jest")({
            --   jestCommand = "npx jest",
            --   jestConfigFile = "jest.config.json",
            --   env = { CI = true },
            --   cwd = function(path)
            --     return vim.fn.getcwd()
            --   end,
            -- }),
            require("neotest-vitest")({
              cwd = function(path)
                -- Find the position of "CrossplatformWeb" in the path
                local _, finish = string.find(path, "CrossplatformWeb")
                if finish then
                  -- Return the substring from the start of the path to the end of "CrossplatformWeb"
                  return string.sub(path, 1, finish)
                end
                return nil -- Return the original path if "CrossplatformWeb" is not found
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
