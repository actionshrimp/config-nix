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
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " m" -- Same for `maplocalleader`

local lazy_spec = {
  "nvim-tree/nvim-web-devicons",
  "tpope/vim-repeat",
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").create_default_mappings()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({})
    end,
  },
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
    },
  },
  --{ "folke/neoconf.nvim", cmd = "Neoconf" },
  { "neovim/nvim-lspconfig" },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
      messages = {
        enabled = false,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/lazydev.nvim",
    opts = {},
    config = function()
      require("lazydev").setup({})
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        },
      })
    end,
  },
  require("treesitter").plugins(),
  require("tree").plugins(),
  {
    "echasnovski/mini.bracketed",
    version = "*",
    opts = {},
  },
  {
    "echasnovski/mini.notify",
    version = "*",
    config = function()
      require("mini.notify").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "direnv/direnv.vim" },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<LEADER>au", ":UndotreeToggle<CR>")
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  require("theme").plugins(),
  require("completion").plugins(),
  require("git").plugins(),
  require("project").plugins(),
  require("search").plugins(),
  require("formatter").plugins(),
  require("diagnostics").plugins(),
  require("llm").plugins(),
  require("lang/org").plugins(),
  require("lang/ocaml").plugins(),
}
require("lazy").setup({
  dev = { path = "~/dev/nvim" },
  spec = lazy_spec,
})

vim.cmd.set("number")
-- always show the column with lsp diagnostic 'E' or 'W' in
vim.cmd.set("signcolumn=yes")

require("keys").init()
require("git").init()
require("diagnostics").init()
require("formatter").init()
require("search").init()

require("lang/lua").init()
require("lang/json").init()
require("lang/nix").init()
require("lang/ocaml").init()
