local M = {}
M.plugins = function()
  return {
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },
    { "linrongbin16/gitlinker.nvim", opts = {}, cmd = "GitLink" },
    {
      "NeogitOrg/neogit",
      dev = true,
      dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("neogit").setup({
          mappings = {
            popup = {
              ["p"] = "PushPopup",
              ["F"] = "PullPopup",
              ["O"] = "ResetPopup",
            },
          },
        })

        vim.keymap.set("n", "<LEADER>gs", ":Neogit<CR>", {})
        vim.keymap.set("n", "<LEADER>gfl", function()
          local f = vim.fn.expand("%")
          require("neogit").action("log", "log_current", { "--", f })()
        end, { desc = "Git log current file" })
      end,
    },
    {
      "FabijanZulj/blame.nvim",
      config = function()
        require("blame").setup()
        vim.keymap.set("n", "<LEADER>gb", ":BlameToggle<CR>", {})
      end,
    },
  }
end

return M
