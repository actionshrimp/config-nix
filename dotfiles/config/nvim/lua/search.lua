local M = {}
M.plugins = function()
  return { {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({})
    end
  }, {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      local t = require 'telescope'
      t.setup({})
      t.load_extension("live_grep_args")
      t.load_extension('projects')
    end

  }, {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('spectre').setup({})
    end
  } }
end


M.init = function()
  vim.keymap.set('n', '<LEADER>pf', ":Telescope find_files<CR>", { desc = "Find project files" });
  vim.keymap.set('n', '<LEADER>pp', function() require 'telescope'.extensions.projects.projects {} end,
    { desc = "Find project" })
  vim.keymap.set('n', '<LEADER>bb', ":Telescope buffers<CR>", { desc = "Buffers" });
  vim.keymap.set('n', '<LEADER>fr', ":Telescope oldfiles<CR>", { desc = "Recent files" });

  vim.keymap.set('n', '<LEADER>/', function()
    require("telescope").extensions.live_grep_args.live_grep_args()
  end, { desc = "Search" });
  vim.keymap.set('n', '<LEADER>*', function()
    require('telescope.builtin').live_grep { default_text = vim.fn.expand("<cword>") }
  end, { desc = "Search word under cursor" });

  -- clear search
  vim.keymap.set('n', '<LEADER>sc', ":noh<CR>", {});

  -- /g flag for :%s on by default
  vim.cmd.set('gdefault')

  vim.keymap.set('n', 'R', function()
    local w = vim.fn.expand('<cword>')
    return ":%s/\\<" .. w .. "\\>/"
  end, { desc = "Replace in current file", expr = true })

  vim.keymap.set('n', '<leader>pR', function()
    require("spectre").open_visual({
      select_word = true,
      begin_line_num = 5,
      is_insert_mode = true,
      path = "*",
    })
  end, { desc = "Replace current word" })
end
return M
