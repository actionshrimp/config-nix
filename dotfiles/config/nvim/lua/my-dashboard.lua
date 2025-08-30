local M = {
  sections = {
    { section = "header" },
    -- { section = "keys", gap = 1, padding = 1 },
    --
    {
      icon = " ",
      desc = "Config",
      padding = 1,
      key = "c",
      action = function()
        require("snacks").picker.files({
          dirs = { "~/config-nix" },
        })
      end,
    },
    {
      icon = " ",
      desc = "GN (web)",
      padding = 1,
      key = "w",
      action = function()
        require("snacks").picker.files({
          dirs = { "~/dev/gn/goodnotes-5/CrossplatformWeb" },
        })
      end,
    },
    {
      icon = " ",
      desc = "GN (root)",
      padding = 1,
      key = "r",
      action = function()
        require("snacks").picker.files({
          dirs = { "~/dev/gn/goodnotes-5" },
        })
      end,
    },
    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = function()
        return Snacks.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = "startup" },
  },
}

return M
