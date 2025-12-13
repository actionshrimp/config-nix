local M = {}

M.plugins = function()
  return {
    {
      "chipsenkbeil/org-roam.nvim",
      dependencies = {
        {
          "nvim-orgmode/orgmode",
        },
      },
      config = function()
        require("org-roam").setup({
          directory = "~/Documents/notes/org-roam",
        })
      end,
    },
  }
end
return M
