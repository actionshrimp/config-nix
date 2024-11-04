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
            { "<leader>ad", group = "Direnv" },
            { "<leader>ads", ":DirenvStatus<cr>", desc = "Status" },
            { "<leader>ada", ":DirenvAllow<cr>", desc = "Allow" },

            -- "Buffer"
            { "<leader>b", group = "Buffer" },
            { "<leader>bd", ":bd<CR>", desc = "Delete" },

            -- "File"
            { "<leader>f", group = "File" },
            { "<leader>fe", group = "Edit" },
            { "<leader>fed", ":e $MYVIMRC<CR>", desc = "Edit init.lua" },
            { "<leader>feh", ":e ~/config-nix/home/default.nix<CR>", desc = "Edit home/default.nix" },
            { "<leader>fec", ":e ~/config-nix/flake.nix<CR>", desc = "Edit flake.nix" },
            { "<leader>fek", ":e ~/config-nix/dotfiles/config/nvim/lua/keys.lua<CR>", desc = "Edit keys.lua" },

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
            { "<leader>gl", group = "Link" },
            { "<leader>gll", "<cmd>GitLink! browse<cr>", desc = "Open blob URL" },
            { "<leader>glL", "<cmd>GitLink browse<cr>", desc = "Copy blob URL" },
            { "<leader>glb", "<cmd>GitLink! blame<cr>", desc = "Open blame URL" },
            { "<leader>glB", "<cmd>GitLink blame<cr>", desc = "Copy blame URL" },

            -- "Major"
            { "<leader>m", group = "Major" },
            { "<leader>ma", group = "Action" },
            { "<leader>maa", vim.lsp.buf.code_action, desc = "LSP Code action" },

            { "<leader>mb", group = "LSP Backend" },
            { "<leader>mbr", ":LspRestart<CR>", desc = "Restart" },

            { "<leader>mR", vim.lsp.buf.rename, desc = "LSP Rename" },

            { "<leader>mg", group = "Go" },
            { "<leader>mgg", vim.lsp.buf.definition, desc = "Definition" },
            { "<leader>mgg", vim.lsp.buf.type_definition, desc = "Type definition" },
            { "<leader>mgb", "<C-o>", desc = "Back" },

            { "<leader>mt", group = "Test" },

            -- "N (?)"
            --{ "<leader>nl", require("telescope").extensions.notify.notify, desc = "Notification log" },

            -- "Toggle"
            { "<leader>t", group = "Toggle" },
            { "<leader>tw", "<cmd>set list!<cr>", desc = "Whitespace" },
            { "<leader>tl", "<cmd>set wrap!<cr>", desc = "Linewrap" },
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
