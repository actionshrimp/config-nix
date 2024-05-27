-- For nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.g.mapleader = " "       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " m" -- Same for `maplocalleader`

local lazy_setup = ({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  --{ "folke/neoconf.nvim", cmd = "Neoconf" },
  {"neovim/nvim-lspconfig"},
  {"folke/neodev.nvim", opts = {}, config = function() require('neodev').setup({}) end},
  "rebelot/kanagawa.nvim",
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end
  },
  { "nvim-treesitter/nvim-treesitter" },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        hint = "floating-big-letter"
      })
    end,
  },
  require('tree').plugins(),
  { 'tpope/vim-unimpaired' },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  { "direnv/direnv.vim", },
  require('git').plugins(),
  require('search').plugins(),
  require('formatter').plugins(),
  require('diagnostics').plugins(),
  require('lang/org').plugins()
})
require("lazy").setup(lazy_setup)

vim.cmd('colorscheme kanagawa')

require('keys').init()
require('git').init()
require('diagnostics').init()
require('formatter').init()
require('search').init()

require('lang/lua').init()
require('lang/json').init()
require('lang/nix').init()
require('lang/ocaml').init()
require('lang/org').init()
