local function plugins()
	return { {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-project.nvim'
		},
		config = function()
			require 'telescope'.load_extension('project')
		end

	}, {
	} }
end


local function init()
	vim.keymap.set('n', '<LEADER>pf', ":Telescope find_files<CR>", { desc = "Find project files" });
	vim.keymap.set('n', '<LEADER>pp', function() require 'telescope'.extensions.project.project {} end,
		{ desc = "Find project" })
	vim.keymap.set('n', '<LEADER>/', ":Telescope live_grep<CR>", { desc = "Search" });
	vim.keymap.set('n', '<LEADER>*', function()
		require('telescope.builtin').live_grep { default_text = vim.fn.expand("<cword>") }
	end, { desc = "Search word under cursor" });
end

return { plugins = plugins, init = init }
