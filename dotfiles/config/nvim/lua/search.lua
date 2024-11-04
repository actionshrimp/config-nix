local M = {}
M.plugins = function()
  return {
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
      config = function()
        local t = require("telescope")
        t.setup({})
        t.load_extension("live_grep_args")
        t.load_extension("projects")
        t.load_extension("yank_history")
      end,
    },
    {
      -- Gives :Subvert command (case aware substitute)
      "tpope/vim-abolish",
    },
    {
      -- Gives preview for vim-abolish
      "markonm/traces.vim",
      config = function()
        vim.cmd("let g:traces_abolish_integration = 1")
      end,
    },
    {
      -- Gives yankring
      "gbprod/yanky.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("yanky").setup({
          highlight = {
            timer = 200,
          },
        })
        vim.keymap.set({ "n", "v" }, "<LEADER>ry", function()
          require("telescope").extensions.yank_history.yank_history()
        end, { desc = "Yank history" })
      end,
    },
  }
end

M.init = function()
  require("which-key").add({
    {
      {
        mode = "n",
        { "<leader>ln", require("telescope").extensions.notify.notify, desc = "Log (notifications)" },

        -- project
        { "<leader>pf", ":Telescope find_files<CR>", desc = "Find project files" },
        {
          "<leader>pp",
          function()
            require("telescope").extensions.projects.projects({})
          end,
          desc = "Find project",
        },

        -- buffer
        { "<leader>bb", ":Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>fr", ":Telescope oldfiles<CR>", desc = "Recent files" },
        { "<leader>rl", ":Telescope resume<CR>", desc = "Resume search" },

        -- search
        {
          "<LEADER>/",
          function()
            require("telescope").extensions.live_grep_args.live_grep_args()
          end,
          desc = "Search",
        },
        {
          "<LEADER>*",
          function()
            require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
          end,
          desc = "Search word under cursor",
        },
        { "<LEADER>sc", ":noh<CR>", desc = "Clear search" },
      },
      {
        mode = { "n", "v" },
        {

          {
            "R",
            function()
              local w = vim.fn.expand("<cword>")
              return ":%S/" .. w .. "/"
            end,
            desc = "Replace in current file",
            expr = true,
          },
          {
            "R",
            function()
              local w = vim.fn.expand("<cword>")
              return ":S/" .. w .. "/"
            end,
            desc = "Replace in current file",
            expr = true,
          },
        },
      },
    },
  })

  -- /g flag for :%s on by default
  vim.cmd.set("gdefault")
  vim.cmd.set("ignorecase")
  vim.cmd.set("smartcase")
end
return M
