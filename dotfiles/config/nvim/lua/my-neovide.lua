local M = {}
M.plugins = function()
  return {}
end
M.init = function()
  if vim.g.neovide then
    vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
    vim.keymap.set("n", "<D-=>", function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end)
    vim.keymap.set("n", "<D-->", function()
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    end)
  end
end
return M
