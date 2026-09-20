local M = {
  width = 100,
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
    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    { section = "startup" },
  },
}

return M
