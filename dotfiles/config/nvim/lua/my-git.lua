local M = {}
M.plugins = function()
  return {
    { "echasnovski/mini.diff", version = "*", opts = {} },
    { "linrongbin16/gitlinker.nvim", opts = {}, cmd = "GitLink" },
    {
      "sindrets/diffview.nvim",
      dev = true,
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
      "actionshrimp/gitlad.nvim",
      dev = true,
      opts = {},
    },
    {
      "pwntester/octo.nvim",
      keys = {
        {
          "<leader>gor",
          function()
            local last_two_months = os.date("%Y-%m-%d", os.time() - (2 * 30 * 24 * 60 * 60))
            vim.cmd("Octo search user-review-requested:@me is:pr is:open created:>=" .. last_two_months)
          end,
          desc = "PRs to Review",
          remap = false,
        },
      },
      config = function()
        require("octo").setup({
          picker = "snacks",
        })
      end,
    },
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
