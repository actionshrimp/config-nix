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
	"folke/neodev.nvim",
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
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
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
	require('search').plugins(),
	require('formatter').plugins(),
	require('diagnostics').plugins(),
})
require("lazy").setup(lazy_setup)

vim.cmd('colorscheme kanagawa')
-- vim.api.nvim_set_keymap('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { noremap = true, silent = true });
-- vim.api.nvim_create_user_command('EditVimrc', ':e $MYVIMRC', {})
vim.keymap.set('n', '<LEADER>fed', ":e $MYVIMRC<CR>", { desc = "Edit init.lua" });
vim.keymap.set('n', '<LEADER>feh', ":e ~/config-nix/home/default.nix<CR>", {});
vim.keymap.set('n', '<LEADER>fec', ":e ~/config-nix/flake.nix<CR>", {});
vim.keymap.set('n', '<LEADER>gs', ":Neogit<CR>", {});
vim.keymap.set('n', '<LEADER>pt', ":Neotree<CR>", {});
vim.keymap.set('n', '<LEADER>sc', ":noh<CR>", {});

vim.api.nvim_create_user_command('W', ':w', {})
vim.api.nvim_create_user_command('Wq', ':wq', {})
vim.api.nvim_create_user_command('Wqa', ':wqa', {})

require('diagnostics').init()
require('formatter').init()
require('search').init()

require('lang/lua')
require('lang/json')
