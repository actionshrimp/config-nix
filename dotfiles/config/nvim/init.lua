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
    "--branch=main", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " m" -- Same for `maplocalleader`

if vim.g.neovide then
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
end

local lazy_spec = {
  {
    "actionshrimp/keychain-environment.nvim",
    opts = {},
  },
  {
    "willothy/flatten.nvim",
    -- keep near the top to minimize delay when opening file from terminal
    opts = {
      window = {
        open = "tab",
      },
      block_for = {
        zsh = true,
      },
    },
    lazy = false,
    priority = 1001,
  },
  require("my-lsp").plugins(),
  {
    "actionshrimp/direnv.nvim",
    dev = true,
    opts = {
      async = true,
      on_direnv_finished = function()
        vim.cmd("LspStart")
      end,
    },
  },
  require("keys").plugins(),
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
  require("my-completion").plugins(),
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
  require("my-treesitter").plugins(),
  require("my-tree").plugins(),
  { "echasnovski/mini.bracketed", version = "*", opts = {} },
  { "echasnovski/mini.ai", version = "*", opts = {} },
  require("my-notifications").plugins(),
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          visual = "s",
        },
      })
    end,
  },
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
  "benoror/gpg.nvim",
  require("my-dashboard").plugins(),
  require("theme").plugins(),
  require("my-git").plugins(),
  require("project").plugins(),
  require("search").plugins(),
  require("my-formatter").plugins(),
  require("my-diagnostics").plugins(),
  require("llm").plugins(),
  require("lang/ocaml").plugins(),
  require("lang/sql").plugins(),
  require("my-kubernetes").plugins(),
  require("my-org").plugins(),
  require("my-lc").plugins(),
  require("my-neotest").plugins(),
  require("my-pomo").plugins(),
  require("my-terminal").plugins(),
}
require("lazy").setup({
  dev = { path = "~/dev/nvim" },
  spec = lazy_spec,
})

vim.cmd.set("number")
vim.cmd.set("list")
-- always show the column with lsp diagnostic 'E' or 'W' in
vim.cmd.set("signcolumn=yes")
vim.cmd.set("expandtab")
vim.cmd.set("shiftwidth=2")
vim.cmd.set("tabstop=2")
-- hide e.g. markdown markers, but leave spaces where they are so everything doesn't shift around
vim.cmd.set("conceallevel=1")

require("keys").init()
require("my-diagnostics").init()
require("search").init()
require("my-treesitter").init()

require("lang/lua").init()
require("lang/json").init()
require("lang/nix").init()
require("lang/ocaml").init()
require("lang/shell").init()
require("lang/gleam").init()
require("lang/python").init()
require("lang/go").init()
require("lang/sql").init()
require("lang/elixir").init()
require("lang/typescript").init()
require("my-web").init()
require("lang/helm").init()
require("lang/terraform").init()
require("my-pomo").init()
require("my-terminal").init()
require("my-neovide").init()
require("lang/swift").init()
