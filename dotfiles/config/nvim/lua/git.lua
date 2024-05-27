function plugins()
  return { {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim",
    },
    config = function ()
      require('neogit').setup({
        mappings = {
          popup = {
            ["p"] = "PushPopup",
            ["P"] = "PullPopup"
          }
        }
      })
    end
  } }
end

function init()
  vim.keymap.set('n', '<LEADER>gs', ":Neogit<CR>", {});
  -- vim.keymap.set('n', '<LEADER>gfl', ":Gllog %<CR>", { desc = "Git log current file" });
  vim.keymap.set('n', '<LEADER>gfl', function()
    local f = vim.fn.expand('%')
    require('neogit').action('log', 'log_current', { "--", f })()
  end, { desc = "Git log current file" });
end

return { plugins = plugins, init = init }
