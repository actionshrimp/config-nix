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
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup({})
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      image = {
        enabled = false,
      },
      picker = {
        ui_select = true,
        frecency = true,
        fuzzy = true,
      },
      dashboard = require("my-dashboard"),
    },
  },
  { "gbprod/yanky.nvim", opts = {} },
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
  require("my-treesitter").plugins(),
  -- require("my-tree").plugins(),
  { "echasnovski/mini.bracketed", version = "*", opts = {} },
  { "echasnovski/mini.ai", version = "*", opts = {} },
  {
    "echasnovski/mini.files",
    version = "*",
    opts = {
      windows = {
        preview = true,
        width_preview = 50,
      },
    },
  },
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
  "benoror/gpg.nvim",
  require("theme").plugins(),
  require("my-git").plugins(),
  require("project").plugins(),
  require("my-formatter").plugins(),
  require("my-diagnostics").plugins(),
  require("llm").plugins(),
  require("lang/ocaml").plugins(),
  require("lang/sql").plugins(),
  require("my-kubernetes").plugins(),
  require("my-org").plugins(),
  require("my-neotest").plugins(),
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
require("my-search").init()
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
require("my-terminal").init()
require("my-neovide").init()
require("lang/swift").init()
