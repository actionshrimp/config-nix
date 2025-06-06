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
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
end
return M
