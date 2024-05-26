local function plugins()
  return { {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            window_picker = {
              enable = true,
              picker = require('window-picker').pick_window,
            }
          }
        },
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set('n', 'oh', api.node.open.vertical, opts('Open: Horizontally'))
          vim.keymap.set('n', 'ov', api.node.open.horizontal, opts('Open: Vertically'))
        end
      })
      vim.keymap.set('n', '<LEADER>pt', ":NvimTreeToggle<CR>", {});
    end,
  },
    -- {
    -- 	"nvim-neo-tree/neo-tree.nvim",
    -- 	branch = "v3.x",
    -- 	dependencies = {
    -- 		"nvim-lua/plenary.nvim",
    -- 		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    -- 		"MunifTanjim/nui.nvim",
    -- 		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    -- 	},
    -- 	config = function()
    -- 		require('neo-tree').setup({
    -- 			window = {
    -- 				mappings = {
    -- 					["<tab>"] = "open",
    -- 				}
    -- 			}
    -- 		})
    -- 	end
    -- },
  }
end

return { plugins = plugins }
