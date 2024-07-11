local M = {}
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

        vim.keymap.set("n", "<LEADER>aodt", ":Neorg journal today<CR>", { desc = "Neorg journal today" })
      end,
    },
  }
end
return M
