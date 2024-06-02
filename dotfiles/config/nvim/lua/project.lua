local M = {}
M.plugins = function()
  return {
    {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          detection_methods = { "pattern" },
          patterns = { ".git" },
          -- exclude_dirs = {
          --   '~/config-nix/dotfiles/config/nvim',
          --   "~/dev/ai/imandra-web/app-www"
          -- },
        })
      end,
    },
  }
end
return M
