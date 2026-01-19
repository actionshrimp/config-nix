local M = {}
M.plugins = function()
  return {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        open_mapping = [[<c-\>]],
        auto_scroll = false,
        terminal_mappings = false,
      },
    },
  }
end
M.init = function()
  vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no")
  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", [[<C-\><C-\>]], [[<C-\><C-n>]], opts)
    -- Use smart-splits for Zellij-aware navigation
    vim.keymap.set("t", "<C-h>", require("smart-splits").move_cursor_left, opts)
    vim.keymap.set("t", "<C-j>", require("smart-splits").move_cursor_down, opts)
    vim.keymap.set("t", "<C-k>", require("smart-splits").move_cursor_up, opts)
    vim.keymap.set("t", "<C-l>", require("smart-splits").move_cursor_right, opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
end
return M
