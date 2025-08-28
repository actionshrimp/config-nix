local M = {}
M.plugins = function()
  return {
    { "echasnovski/mini.diff", version = "*", opts = {} },
    { "linrongbin16/gitlinker.nvim", opts = {}, cmd = "GitLink" },
    {
      "sindrets/diffview.nvim",
      opts = {
        keymaps = {
          view = {
            ["q"] = "<cmd>tabclose<cr>",
          },
          file_panel = {
            ["q"] = "<cmd>tabclose<cr>",
          },
        },
      },
      -- cmd = "DiffviewOpen",
    },
    { "tpope/vim-fugitive" },
    {
      "NeogitOrg/neogit",
      dev = true,
      dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "folke/snacks.nvim", -- optional - picker
      },
      config = function()
        require("neogit").setup({
          auto_show_console = false,
          console_timeout = 10000,
          auto_refresh = false,
          mappings = {
            popup = {
              ["p"] = "PushPopup",
              ["F"] = "PullPopup",
              ["O"] = "ResetPopup",
              ["z"] = "StashPopup",
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
