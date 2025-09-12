local M = {}

M.plugins = function()
  return {
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
        spec = {
          {
            mode = { "n" },
            { "<leader>c", group = "Comment", { "<leader>cl", "gcc", desc = "Line", remap = true } },
          },
          {
            mode = { "v" },
            { "<leader>c", group = "Comment", { "<leader>cl", "gc", desc = "Line", remap = true } },
          },
          {
            mode = { "n", "v" },

            -- "Apps"
            { "<leader>a", group = "Apps" },
            { "<leader>aa", group = "Avante" },

            { "<leader>ac", group = "Claude Code" },
            { "<leader>acc", ":ClaudeCode<CR>", desc = "Toggle" },

            { "<leader>ad", group = "Direnv" },
            { "<leader>ads", ":DirenvStatus<cr>", desc = "Status" },
            { "<leader>ada", ":DirenvAllow<cr>", desc = "Allow" },
            { "<leader>aD", group = "Database (dadbod)" },
            { "<leader>aDD", ":DBUIToggle<CR>", desc = "Toggle" },

            -- "Buffer"
            { "<leader>b", group = "Buffer" },
            { "<leader>bd", ":bd<CR>", desc = "Delete" },

            -- "File"
            { "<leader>f", group = "File" },
            { "<leader>fe", group = "Edit" },
            {
              "<leader>fee",
              function()
                require("snacks").picker.files({
                  dirs = { "~/config-nix" },
                })
              end,
              desc = "Search config",
            },
            { "<leader>fed", ":e $MYVIMRC<CR>", desc = "Edit init.lua" },
            {
              "<leader>feD",
              function()
                require("snacks").dashboard()
              end,
              desc = "View dashboard",
            },
            { "<leader>feh", ":e ~/config-nix/home/default.nix<CR>", desc = "Edit home/default.nix" },
            { "<leader>fec", ":e ~/config-nix/flake.nix<CR>", desc = "Edit flake.nix" },
            { "<leader>fek", ":e ~/config-nix/dotfiles/config/nvim/lua/keys.lua<CR>", desc = "Edit keys.lua" },

            { "<leader>p", group = "Project" },
            {
              "<leader>pt",
              function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
              end,
              desc = "Tree",
            },
            {
              "<leader>pT",
              function()
                require("mini.files").open(nil, false)
              end,
              desc = "Project (fresh)",
            },
            { "<leader>fy", group = "Yank" },
            {
              "<leader>fyy",
              function()
                local f = vim.fn.expand("%:p")
                vim.fn.setreg("+", f)
                print(f)
              end,
              desc = "Current filename",
            },

            -- "Git"
            { "<leader>g", group = "Git" },
            { "<leader>gl", group = "File" },
            {
              "<leader>gfl",
              function()
                local f = vim.fn.expand("%")
                require("snacks").picker.git_log_file()
              end,
              desc = "Log",
            },

            {
              "<leader>gL",
              function()
                local f = vim.fn.expand("%")
                require("snacks").picker.git_log()
              end,
              desc = "Log",
            },

            { "<leader>gl", group = "Link" },
            { "<leader>gll", "<cmd>GitLink! browse<cr>", desc = "Open blob URL" },
            { "<leader>glL", "<cmd>GitLink browse<cr>", desc = "Copy blob URL" },
            { "<leader>glb", "<cmd>GitLink! blame<cr>", desc = "Open blame URL" },
            { "<leader>glB", "<cmd>GitLink blame<cr>", desc = "Copy blame URL" },

            {
              "<leader>gO",
              function()
                require("mini.diff").toggle_overlay()
              end,
              desc = "Overlay",
            },
            { "<leader>gl", group = "Octo" },

            -- "Major"
            { "<leader>m", group = "Major" },
            { "<leader>ma", group = "Action" },
            { "<leader>maa", vim.lsp.buf.code_action, desc = "LSP Code action" },

            { "<leader>mb", group = "LSP Backend" },
            { "<leader>mbr", ":LspRestart<CR>", desc = "Restart" },

            { "<leader>mR", vim.lsp.buf.rename, desc = "LSP Rename" },

            { "<leader>mg", group = "Go" },
            { "<leader>mgg", vim.lsp.buf.definition, desc = "Definition" },
            { "<leader>mgt", vim.lsp.buf.type_definition, desc = "Type definition" },
            { "<leader>mgb", "<C-o>", desc = "Back" },

            { "<leader>md", group = "Debug" },
            { "<leader>mdb", ":DapToggleBreakpoint<CR>", desc = "Breakpoint" },
            { "<leader>mdn", ":DapNew<CR>", desc = "New session" },
            { "<leader>mdc", ":DapContinue<CR>", desc = "Continue" },
            { "<leader>mdj", ":DapStepOver<CR>", desc = "Step Over" },
            { "<leader>mdl", ":DapStepInto<CR>", desc = "Step Into" },

            { "<leader>mt", group = "Test" },

            -- "N (?)"
            --{ "<leader>nl", require("telescope").extensions.notify.notify, desc = "Notification log" },

            -- "Toggle"
            { "<leader>t", group = "Toggle" },
            { "<leader>tw", "<cmd>set list!<cr>", desc = "Whitespace" },
            { "<leader>tl", "<cmd>set wrap!<cr>", desc = "Linewrap" },
            { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close Tab" },
            { "<leader>tC", "<cmd>CccPick<cr>", desc = "Pick Colour" },
          },
        },
      },
    },
  }
end
M.init = function()
  vim.api.nvim_create_user_command("W", ":w", {})
  vim.api.nvim_create_user_command("Wq", ":wq", {})
  vim.api.nvim_create_user_command("Wqa", ":wqa", {})
  vim.api.nvim_create_user_command("Qa", ":wqa", {})
  vim.api.nvim_create_user_command("E", ":e", {})

  -- commenting
  vim.keymap.set("v", "<LEADER>cl", "gc", { remap = true, desc = "Comment selection" })

  -- system clipboard
  vim.keymap.set("v", "<LEADER>xy", '"+y', { remap = true, desc = "Clipboard yank" })
  vim.keymap.set("n", "<LEADER>xp", '"+p', { remap = true, desc = "Clipboard paste" })

  -- :help CTRL-W
  vim.keymap.set("n", "<LEADER>w<S-l>", "<C-w><S-l>", {})
  vim.keymap.set("n", "<LEADER>w<S-h>", "<C-w><S-h>", {})
  vim.keymap.set("n", "<LEADER>wm", "<C-w>o", {})
end
return M
