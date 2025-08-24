local M = {}

local function grep_at_current_tree_node()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end
  require("snacks").picker.grep({ dirs = { node.absolute_path } })
end

M.plugins = function()
  return {
    {
      "s1n7ax/nvim-window-picker",
      name = "window-picker",
      event = "VeryLazy",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          hint = "floating-big-letter",
        })
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      event = "VeryLazy",
      config = function()
        require("nvim-tree").setup({
          git = { enable = false },
          sync_root_with_cwd = false,
          respect_buf_cwd = true,
          update_focused_file = {
            enable = false,
            update_root = false,
          },
          actions = {
            open_file = {
              window_picker = {
                enable = true,
                picker = require("window-picker").pick_window,
              },
            },
          },
          on_attach = function(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
              return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            -- see https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt#L2230 for defaults
            vim.keymap.set("n", "oh", api.node.open.vertical, opts("Open: Horizontally"))
            vim.keymap.set("n", "ov", api.node.open.horizontal, opts("Open: Vertically"))
            vim.keymap.set("n", "<ret>", api.node.open.no_window_picker, opts("Open: Vertically"))
            vim.keymap.set("n", "oa", api.node.open.edit, opts("Open: Vertically"))
            vim.keymap.set("n", "<LEADER>/", grep_at_current_tree_node, { buffer = bufnr })
          end,
        })
        vim.keymap.set("n", "<LEADER>pt", ":NvimTreeToggle .<CR>", { desc = "Open tree" })
        vim.keymap.set("n", "<LEADER>pTr", function()
          local f = vim.fs.root(0, ".git")
          require("nvim-tree.api").tree.change_root(f)
        end, { desc = "Update tree root for file" })
        vim.keymap.set("n", "<LEADER>pTf", ":NvimTreeFindFile<CR>", { desc = "Focus tree on file" })
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
return M
