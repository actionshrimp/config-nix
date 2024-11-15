local M = {}

M.neorg_roam = function()
  require("telescope.builtin").find_files({
    prompt_title = "Notebook",
    cwd = "~/Dropbox/notes",
  })
end

M.plugins = function()
  return {
    {
      "nvim-neorg/neorg",
      lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
      version = "*", -- Pin Neorg to the latest stable release
      config = function()
        require("neorg").setup({
          load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
              config = {
                workspaces = {
                  notes = "~/Dropbox/notes",
                },
                default_workspace = "notes",
              },
            },
            ["core.journal"] = {},
          },
        })

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2

        vim.keymap.set("n", "<LEADER>aordt", ":Neorg journal today<CR>", { desc = "Neorg journal today" })
        vim.keymap.set("n", "<LEADER>aordy", ":Neorg journal yesterday<CR>", { desc = "Neorg journal yesterday" })
        vim.keymap.set("n", "<LEADER>aordT", ":Neorg journal tomorrow<CR>", { desc = "Neorg journal tomorrow" })
        vim.keymap.set("n", "<LEADER>aorf", M.neorg_roam, { desc = "Neorg find" })

        -- useful reference https://github.com/nvim-neorg/neorg/wiki/Default-Keybinds
        vim.keymap.set("n", "<LEADER>aorc", "<Plug>(neorg.dirman.new-note)", { desc = "Neorg capture" })
      end,
    },
  }
end
return M
