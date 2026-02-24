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
      opts = {
        watcher = {
          enabled = true,
          auto_refresh = true,
        },
        worktree = {
          directory_strategy = "sibling-bare",
        },
        status = {
          sections = {
            "rebase_sequence",
            "untracked",
            "unstaged",
            "staged",
            "conflicted",
            "stashes",
            -- "submodules",  -- uncomment to show submodules section
            "unpushed",
            "unpulled",
            { "recent", count = 10 }, -- limit recent commits shown
            { "worktrees", min_count = 2 }, -- only show if >= min_count worktrees
          },
        },
      },
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
