local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " m" -- Same for `maplocalleader`

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
  "rebelot/kanagawa.nvim",
  {
  "NeogitOrg/neogit",
  dependencies = {
	  "nvim-lua/plenary.nvim",         -- required
	  "sindrets/diffview.nvim",        -- optional - Diff integration

	  -- Only one of these is needed, not both.
	  "nvim-telescope/telescope.nvim", -- optional
	  "ibhagwan/fzf-lua",              -- optional
  },
  config = true
}
})

vim.cmd('colorscheme kanagawa')
-- vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { noremap = true, silent = true });
vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", {});
vim.api.nvim_set_keymap('n', '<LEADER>gs', ":Neogit<CR>", {});
